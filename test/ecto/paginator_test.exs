defmodule UtilityBelt.PaginatorTest do
  @moduledoc false
  use ExUnit.Case
  alias UtilityBelt.Ecto.Paginator

  test "get cursor" do
    assert {10, 0} = Paginator.get_cursor(nil)
    assert {10, 0} = Paginator.get_cursor(%{})
    assert {100, 0} = Paginator.get_cursor(%{paging: %{size: 100}})
    assert {655, 20} = Paginator.get_cursor(%{paging: %{size: 655, cursor: Cipher.encrypt("20")}})
  end

  test "get page info" do
    cursor = Cipher.encrypt("0")
    assert %{total: 100, next: false, cursor: ^cursor} = Paginator.get_info([], 100, 32, 8)

    cursor = Cipher.encrypt("#{40 + 10}")
    assert %{total: 200, next: true, cursor: ^cursor} = Paginator.get_info([1], 200, 40, 10)
  end
end
