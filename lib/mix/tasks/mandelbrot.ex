defmodule Mix.Tasks.Gnuplot.Mandelbrot do
  use Mix.Task

  alias Gnuplot, as: G

  defp set(xsize \\ 60, ysize \\ 20) do
    minIm = -1.0
    maxIm = 1.0
    minRe = -2.0
    maxRe = 1.0
    stepX = (maxRe - minRe) / xsize
    stepY = (maxIm - minIm) / ysize
    Enum.flat_map(0..ysize, fn y ->
      im = minIm + stepY * y
      Enum.map(0..xsize, fn x ->
        re = minRe + stepX * x
        z = loop(0, re, im, re, im, re*re+im*im)
        [x, y, z]
      end)
    end)
  end

  defp loop(n, _, _, _, _, _) when n>=30, do: n
  defp loop(n, _, _, _, _, v) when v>4.0, do: n-1
  defp loop(n, re, im, zr, zi, _) do
    a = zr * zr
    b = zi * zi
    loop(n+1, re, im, a-b+re, 2*zr*zi+im, a+b)
  end

  @shortdoc "Generate mandelbrot"
  def run(_) do
    {:ok, cmd} = G.plot([
      [:set, :term, :png],
      [:set, :output, "docs/mandelbrot.PNG"],
      [:set, :view, :map],
      [:set, :dgrid3d],
      [:set,  :pm3d, :interpolate, G.list(4, 3)],
      [:splot, "-", :with, :pm3d]

      # [:set,  :pm3d, :interpolate, G.list(4, 4)],
      # [:splot, "-"]
    ],
      [
        set()
      ]
    )
    IO.puts(cmd)
  end
end
