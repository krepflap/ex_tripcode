defmodule ExTripcodeTest do
  use ExUnit.Case
  doctest ExTripcode

  describe "regular tripcodes" do
    test "should generate regular tripcodes" do
      assert ExTripcode.hash("overcompensate") == "sGqtdX5oJc"
      assert ExTripcode.hash("pepperoni") == "HohErJmbN6"
    end

    test "length of regular tripcode should always be 10 chars" do
      assert String.length(ExTripcode.hash("x")) == 10
    end

    test "should work with special chars" do
      assert ExTripcode.hash("廨A齬ﾙｲb") == "sTrIKeleSs"
      assert ExTripcode.hash("エリクサー") == "VTaBo/Ew8o"
      assert ExTripcode.hash("糯ｫT弓(窶") == "Pants.f1Fk"

      assert ExTripcode.hash("$$$$$$$$$$$$$$$$$$") == "dQCqKwAumo"
      assert ExTripcode.hash("€€€€€€€€€€€€€€€€€€") == "bIffqtgKTg"
    end

    test "should work with html chars" do
      assert ExTripcode.hash("&elixir") == "Q8CfKxygXk"
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

  describe "secure tripcodes" do
    @seed """
    FW6I5Es311r2JV6EJSnrR2+hw37jIfGI0FB0XU5+9lua9iCCrwgkZDVRZ+1PuClqC+78FiA6hhh\
    XU1oq6OyFx/MWYx6tKsYeSA8cAs969NNMQ98SzdLFD7ZifHFreNdrfub3xNQBU21rknftdESFRT\
    Ur44nqCZ0wyzVVDySGUZkbtyHhnj+cknbZqDu/wjhX/HjSitRbtotpozhF4C9F+MoQCr3LgKg+C\
    iYHs3Phd3xk6UC2BG2EU83PignJMOCfxzA02gpVHuwy3sx7hX4yvOYBvo0kCsk7B5DURBaNWH0s\
    rWz4MpXRcDletGGCeKOz9Hn1WXJu78ZdxC58VDl20UIT9er5QLnWiF1giIGQXQMqBB+Rd48/suE\
    WAOH2H9WYimTJWTrK397HMWepK6LJaUB5GdIk56ZAULjgZB29qx8Cl+1K0JWQ0SI5LrdjgyZZUT\
    X8LB/6Coix9e6+3c05Pk6Bi1GWsMWcJUf7rL9tpsxROtq0AAQBPQ0rTlstFEziwm3vRaTZvPRbo\
    QfREta09VA+tRiWfN3XP+1bbMS9exKacGLMxR/bmO5A57AgQF+bPjhif5M/OOJ6J/76q0JDHA==\
    """

    test "should generate regular tripcodes with long seed" do
      assert ExTripcode.hash("overcompensate", @seed) == "A97Af57hncyxk2g"
      assert ExTripcode.hash("pepperoni", @seed) == "7qM+7vweIG1RyQc"
    end

    test "length of secure tripcode should always be 15 chars" do
      assert String.length(ExTripcode.hash("x", "secret")) == 15
      assert String.length(ExTripcode.hash("x", @seed)) == 15
    end

    test "empty value should give empty result" do
      assert ExTripcode.hash("", "") == ""
      assert ExTripcode.hash("", "secret") == ""
    end
  end
end
