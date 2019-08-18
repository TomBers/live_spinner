defmodule DemoWeb.Spinner do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div>
    <div>
      <a href="#" phx-click="toggle-mode">Change mode</a>

      <a href="#" phx-click="add-spinner">Add spinner</a>
      <a href="#" phx-click="go">Start/Stop</a>
    </div>

     <span><a href="#" phx-click="inc">+</a><a href="#" phx-click="dec">--</a><span>




    <svg width="99%" height="562px" xmlns="http://www.w3.org/2000/svg">
    <defs>
      <pattern id="smallGrid" width="8" height="8" patternUnits="userSpaceOnUse">
        <path d="M 8 0 L 0 0 0 8" fill="none" stroke="gray" stroke-width="0.5"/>
      </pattern>
      <pattern id="grid" width="80" height="80" patternUnits="userSpaceOnUse">
        <rect width="80" height="80" fill="url(#smallGrid)"/>
        <path d="M 80 0 L 0 0 0 80" fill="none" stroke="gray" stroke-width="1"/>
      </pattern>
    </defs>

    <rect width="100%" height="100%" fill="url(#grid)" />
        <%= if @just_points do %>
          <%= for {x, y, c} <- @draw_points do %>
            <circle cx="<%= x %>" cy="<%= y %>" r="3" stroke="<%= c %>" stroke-width="1" fill="<%= c %>" />
          <% end %>
        <% else %>
            <%= for spinner <- @spinners do %>
              <line x1="<%= spinner.ox %>" y1="<%= spinner.oy %>" x2="<%= spinner.ex %>" y2="<%= spinner.ey %>" style="stroke:rgb(255,0,0);stroke-width:1" />
              <circle cx="<%= spinner.ox %>" cy="<%= spinner.oy %>" r="1" stroke="black" stroke-width="1" fill="black" />
              <circle cx="<%= spinner.ex %>" cy="<%= spinner.ey %>" r="1" stroke="black" stroke-width="1" fill="black" />
            <% end %>
        <% end %>
    </svg>
    </div>

    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: :timer.send_interval(50, self(), :tick)
    origin = 300.0
    l = 50.0
    spinner = %{id: 0, ox: origin, oy: origin, ex: origin + l, ey: origin - 50.0, length: 70.71,  speed: :math.pi / 20}

    {:ok, assign(socket, :spinners, [spinner]) |> assign(:draw_points, []) |> assign(:just_points, false) |> assign(:running, false)}
  end


  def handle_event("inc", params, socket) do
    spinner = List.last(socket.assigns.spinners)
    new_spinner = SpinnerUtil.change_length(spinner, 10)
    {:noreply, assign(socket, :spinners, socket.assigns.spinners |> List.replace_at(spinner.id, new_spinner))}
  end

  def handle_event("inc", params, socket) do
    spinner = List.last(socket.assigns.spinners)
    new_spinner = SpinnerUtil.change_length(spinner, -10)
    {:noreply, assign(socket, :spinners, socket.assigns.spinners |> List.replace_at(spinner.id, new_spinner))}
  end


  def handle_info(:tick, socket) do
    if socket.assigns.running do
      spinners = re_calc(socket.assigns.spinners)
      dp = socket.assigns.draw_points ++ [{List.last(spinners).ex, List.last(spinners).ey, col(length(socket.assigns.draw_points))}]
      {:noreply, assign(socket, :spinners, spinners) |> assign(:draw_points, dp)}
    else
      {:noreply, socket}
    end
  end


  def re_calc(spinners) do
    spinners |> Enum.reduce([], fn(spinner, acc) -> acc ++ [Spinners.calc_spinner(List.last(acc), spinner)] end)
  end

  def handle_event("toggle-mode", _, socket) do
    {:noreply, assign(socket, :just_points, !socket.assigns.just_points)}
  end

  def handle_event("add-spinner", _, socket) do
    last = List.last(socket.assigns.spinners)
    spinners = socket.assigns.spinners ++ [SpinnerUtil.create_spinner(last)]
    {:noreply, assign(socket, :spinners, spinners)}
  end


  def handle_event("go", _, socket) do
    {:noreply, assign(socket, :running, !socket.assigns.running)}
  end


  def col(n) do
    n =
      if n == 0 do
        1
      else
        n
      end
    alpha = n/1000
    "rgba(124,240,10,#{alpha})"
#    Enum.random(["#E3E84E", "#0F3450", "#200B48", "#C06EA6", "#E2310E"])
  end


end
