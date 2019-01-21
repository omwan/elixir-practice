defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def is_operator?(text) do
    text == "+" or text == "-" or text == "/" or text == "*"
  end

  def tag_tokens(expr) do
    tag_tokens(expr, [])
  end

  def tag_tokens(expr, acc) do
    cond do
      expr == [] ->
        Enum.reverse(acc)
      is_operator?(hd(expr)) ->
        tag_tokens(tl(expr), [{:op, hd(expr)} | acc])
      true ->
        tag_tokens(tl(expr), [{:num, hd(expr)} | acc])
    end
  end

  def higher_precedence?(op1, op2) do
    order = %{"+" => 2, "-" => 2, "/" => 3, "*" => 3}
    Map.get(order, op1) > Map.get(order, op2)
  end

  def postfix(expr) do
    postfix(expr, [], [])
  end

  def postfix(expr, output, operator) do
    cond do
      expr == [] ->
        output ++ operator
      elem(hd(expr), 0) == :op ->
        if operator == [] or higher_precedence?(elem(hd(expr), 1), hd(operator)) do
          postfix(tl(expr), output, [elem(hd(expr), 1) | operator])
        else
          postfix(tl(expr), output ++ [hd(operator)], [elem(hd(expr), 1) | tl(operator)])
        end
      true ->
        postfix(tl(expr), output ++ [elem(hd(expr), 1)], operator)
    end
  end

  def evaluate(expr) do
    evaluate(expr, [])
  end

  def evaluate(expr, acc) do
    cond do
      expr == [] ->
        hd(acc)
      is_operator?(hd(expr)) ->
        case hd(expr) do
          "+" ->
            evaluate(tl(expr), [hd(tl(acc)) + hd(acc) | (tl(tl(acc)))])
          "-" ->
            evaluate(tl(expr), [hd(tl(acc)) - hd(acc) | (tl(tl(acc)))])
          "*" ->
            evaluate(tl(expr), [hd(tl(acc)) * hd(acc) | (tl(tl(acc)))])
          "/" ->
            evaluate(tl(expr), [hd(tl(acc)) / hd(acc) | (tl(tl(acc)))])
        end
      true ->
        evaluate(tl(expr), [parse_float(hd(expr)) | acc])
    end
  end

  def calc(expr) do
    expr
    |> String.split(~r/\s+/)
    |> tag_tokens
    |> postfix
    |> evaluate
  end
end
