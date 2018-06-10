defmodule ProjectTopTest do
  use ExUnit.Case
  alias UtilityBelt.ProjectTop

  test "get project top shall not raise any issue" do
    File.mkdir_p!("deps")
    assert ProjectTop.get() != ""
  end
end
