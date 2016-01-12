defmodule ElmMaru do
end

defmodule ElmMaru.Router do
  
end

defmodule ElmMaru.Router.Homepage do
  use Maru.Router

  get "/api" do
    conn |> json(%{hello: :world})
      # Plug.Conn.send_resp(conn, 200, "hello")
  end
end

defmodule ElmMaru.API do
  use Maru.Router

  mount ElmMaru.Router.Homepage

  rescue_from :all do
    status 500
    "CATCHALL Server Error"
  end
end
