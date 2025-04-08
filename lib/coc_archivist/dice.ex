defmodule CocArchivist.Dice do
  @moduledoc """
  Functions for rolling dice in Call of Cthulhu.
  """

  @doc """
  Rolls a single die with the specified number of sides.

  ## Examples

      iex> roll_die(6)
      4  # Random number between 1 and 6

      iex> roll_die(100)
      42  # Random number between 1 and 100
  """
  def roll_die(sides) when is_integer(sides) and sides > 0 do
    :rand.uniform(sides)
  end

  @doc """
  Rolls multiple dice and returns the sum.

  ## Examples

      iex> roll_dice(2, 6)  # Roll 2d6
      8  # Sum of two random numbers between 1 and 6

      iex> roll_dice(1, 100)  # Roll 1d100
      65  # Random number between 1 and 100
  """
  def roll_dice(count, sides)
      when is_integer(count) and count > 0 and is_integer(sides) and sides > 0 do
    1..count
    |> Enum.map(fn _ -> roll_die(sides) end)
    |> Enum.sum()
  end

  @doc """
  Rolls a percentile dice (d100) and returns the result.

  ## Examples

      iex> roll_percentile()
      42  # Random number between 1 and 100
  """
  def roll_percentile do
    roll_die(100)
  end
end
