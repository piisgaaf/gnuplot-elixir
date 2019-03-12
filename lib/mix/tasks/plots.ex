defmodule Mix.Tasks.Gnuplot.Readme do
  use Mix.Task

  alias Gnuplot, as: G

  defp plot_file(target, cmds, datasets) do
    cmdf =
      Enum.concat(
        [[:set, :term, :png], [:set, :output, target]],
        cmds
      )

    {:ok, _} = G.plot(cmdf, datasets)
  end

  defp rand do
    plot_file(
      "docs/rand.PNG",
      [
        [:set, :key, :left, :top],
        [
          :plot,
          G.list(
            ["-", :title, "uniform", :with, :points],
            ["-", :title, "normal", :with, :points]
          )
        ]
      ],
      [
        for(n <- 0..1000, do: [n, n * :rand.uniform()]),
        for(n <- 0..1000, do: [n, n * :rand.normal()])
      ]
    )
  end

  defp bumps do
    plot_file(
      "docs/bumps.PNG",
      [
        [:set, :view, :map],
        [:set, :dgrid3d],
        [:set,  :pm3d, :interpolate, G.list(2, 2)],
        [:splot, "-", :with, :pm3d]
      ],
      [
        for(x <- -500..500,
            y <- -500..500, do: [x / 10.0,
            y / 10.0,
            (:math.sin(x * 5 / 10.0) * :math.cos(y * 5 / 10.0) / 5.0)])
      ]
    )
  end

  @shortdoc "Generate plots of the README"
  def run(_) do
    rand()
    bumps()
  end
end
