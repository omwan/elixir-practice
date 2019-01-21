defmodule Practice do
  @moduledoc """
  Practice keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def double(x) do
    2 * x
  end

  def calc(expr) do
    # This is more complex, delegate to lib/practice/calc.ex
    Practice.Calc.calc(expr)
  end

  def factor(x) do
    factor(x, 2, [])
  end

  def factor(x, f, acc) do
    cond do
      x < f * f ->
        Enum.reverse([x | acc])
      rem(x, f) == 0 ->
        factor(div(x, f), f, [f | acc])
      true ->
        factor(x, f + 1, acc)
    end
  end

  def palindrome?(str) do
    str == String.reverse(str)
  end
end
