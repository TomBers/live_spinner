defmodule Spinners do

  def calc_spinner(nil, next) do
    calc_new_points(next)
  end

  def calc_spinner(previous, next) do
    update_next_spinner(previous, next) |> calc_new_points
  end

  def update_next_spinner(previous, next) do
    difx = previous.ex - next.ox
    dify = previous.ey - next.oy
    %{next | ox: previous.ex, oy: previous.ey, ex: next.ex + difx, ey: next.ey + dify}
  end

  def calc_new_points(spinner) do
    delta = spinner.speed
    x = spinner.ex - spinner.ox
    y = spinner.ey - spinner.oy

    nx = x * Float.floor(:math.cos(delta), 10) - y * :math.sin(delta)
    ny = x * :math.sin(delta) + y * Float.floor(:math.cos(delta), 10)
    %{spinner | ex: spinner.ox + nx, ey: spinner.oy + ny}
  end

end
