defmodule FetchMeIfYouCan.Job do
  use FetchMeIfYouCan.Web, :model

  schema "jobs" do
    field :job_id, :string
    field :url, :string
    field :title, :string
    field :content, :string
    field :status, :string

    timestamps
  end

  @required_fields ~w(job_id url status)
  @optional_fields ~w(title content)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
