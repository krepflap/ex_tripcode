defmodule ExTripcodeTest do
  use ExUnit.Case
  doctest ExTripcode

  describe "regular tripcodes" do
    test "should generate regular tripcodes" do
      assert ExTripcode.hash("overcompensate") == "sGqtdX5oJc"
      assert ExTripcode.hash("pepperoni") == "HohErJmbN6"
    end

    test "length of regular tripcode should always be 10 chars" do
      assert String.length(ExTripcode.hash("a")) == 10
    end

    test "should work with special chars" do
      assert ExTripcode.hash("廨A齬ﾙｲb") == "sTrIKeleSs"
      assert ExTripcode.hash("エリクサー") == "VTaBo/Ew8o"
      assert ExTripcode.hash("$$$$$$$$$$$$$$$$$$") == "dQCqKwAumo"
      assert ExTripcode.hash("€€€€€€€€€€€€€€€€€€") == "bIffqtgKTg"
    end

    test "should work with short values" do
      assert ExTripcode.hash("a") == "ZnBI2EKkq."
    end

    test "should work with long values" do
      assert ExTripcode.hash("gV4ZhqkrjBka)GiWi(zKJHYPShVN!^TsG%6Xxo9Q") == "3ps/PcSAjk"
    end

    test "however, we expect long values to be cut off after 8 chars" do
      assert ExTripcode.hash("gV4Zhqkr") ==
               ExTripcode.hash("gV4ZhqkrjBka)GiWi(zKJHYPShVN!^TsG%6Xxo9Q")
    end

    test "empty value should give empty result" do
      assert ExTripcode.hash("") == ""
    end
  end
end
