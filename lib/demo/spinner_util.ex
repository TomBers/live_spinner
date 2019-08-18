defmodule SpinnerUtil do

  @origin 300
  @l 50
  @spinner %{id: 0, ox: @origin, oy: @origin, ex: @origin + @l, ey: @origin + @l , length: 70.71,  speed: :math.pi / 20}


  def create_spinner(last) do
    l = Enum.random(10..75)
    speed = Enum.random([:math.pi / 20, :math.pi / 18, :math.pi / 16, :math.pi / 14, :math.pi / 12, :math.pi / 10, :math.pi / 8, :math.pi / 6, :math.pi / 4 ])
    angle = SpinnerUtil.get_angle(last)
    ex = Float.ceil(:math.cos(angle) * l, 10)
    ey = Float.ceil(:math.sin(angle) * l, 10)
    %{id: last.id + 1, ox: last.ex, oy: last.ey, ex: last.ex + ex, ey: last.ey + ey, length: l,  speed: speed}
  end

  def change_length(spinner, new_l) do
    l = spinner.length + new_l
    angle = get_angle(spinner)

    ex = Float.ceil(:math.cos(angle) * l, 10)

    ey = Float.ceil(:math.sin(angle) * l, 10)

    %{id: spinner.id, ox: spinner.ox, oy: spinner.oy, ex: spinner.ox + ex, ey: spinner.oy + ey, length: l,  speed: spinner.speed}
  end

  def get_angle(spinner) do
    o = spinner.ey - spinner.oy
    a = spinner.ex - spinner.ox
    :math.atan(o / a)
  end


#  def get_angle(last) do
#    #    https://onlinemschool.com/math/library/vector/angl/
#    b = {last.ex - last.ox, -1 * (last.ey - last.oy)}
#    a = {last.ox + last.length, -1 * last.oy}
#    dp = dot_product(a, b)
#    mag_a = mag(a)
#    mag_b = mag(b)
#
#    Float.ceil(dp / (mag_a * mag_b), 10)
#  end
#
#  def dot_product({ax, ay}, {bx, by}) do
#    bx * ax + by * ay
#  end
#
#  def mag({x, y}) do
#    tmp = :math.pow(x, 2) + :math.pow(y, 2)
#    :math.sqrt(tmp)
#  end

end
