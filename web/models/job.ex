defmodule FetchMeIfYouCan.Job do
  use FetchMeIfYouCan.Web, :model

  schema "jobs" do
    field :job_id, :string
    field :url, :string
    field :title, :string
    field :content, :string
    field :status, :string, default: "processing"
    field :thumbnail_data, :string
    field :thumbnail_mimetype, :string

    timestamps
  end

  @required_fields ~w(job_id url)
  @optional_fields ~w(title content status thumbnail_data thumbnail_mimetype)

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
