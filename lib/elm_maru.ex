defmodule ElmMaru do
end

defmodule ElmMaru.Router do
  
end

defmodule ElmMaru.Router.Homepage do
  use Maru.Router

  get "/api" do
    {:ok, binary} = File.read("lib/api-response.json")
    result = binary |> Poison.decode!

    conn |> json(result)
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
