defmodule Gnuplot.Datasets do
  @moduledoc """
  Convert Elixir lists to Gnuplot STDIN.

  See http://www.gnuplotting.org/tag/standard-input/
  """

  @doc """
  Convert a list of datasets.

  A dataset is a list of rows, each row is a list of numbers.
  """
  @spec format_datasets(list(list(number()))) :: [String.t()]
  def format_datasets(datasets) do
    Enum.flat_map(datasets, &format_dataset/1)
  end

  defp format_dataset(dataset) do
    dataset
    |> Enum.map(&format_point/1)
    |> Enum.intersperse("\n")
    |> Enum.concat(["\ne\n"])
  end

  @spec format_point(list(number())) :: String.t()
  defp format_point(point) do
    point
    |> Enum.map(&Kernel.to_string/1)
    |> Enum.join(" ")
  end
end
