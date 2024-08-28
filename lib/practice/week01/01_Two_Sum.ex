defmodule Practice.Solution01_01 do



  @spec two_sum(nums :: [integer], target :: integer) :: [integer]
  def two_sum(nums, target) do
    indexed = Enum.with_index(nums)
    sums = for {numberA, indexA} <- indexed do
      for {numberB, indexB} <- Enum.drop(indexed, indexA+1) do
        sum = numberA + numberB
        {sum, indexA, indexB}
      end
    end
    sums = List.flatten(sums)
    result = Enum.find(sums, fn {sum, indexA, indexB} -> sum == target end)
    {target, indexA, indexB} = result
    result = [indexA, indexB]
  end
end
