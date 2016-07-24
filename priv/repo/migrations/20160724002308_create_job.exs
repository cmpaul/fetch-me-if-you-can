defmodule FetchMeIfYouCan.Repo.Migrations.CreateJob do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :job_id, :string
      add :url, :string
      add :title, :string
      add :content, :text
      add :status, :string, default: "processing"
      add :thumbnail_data, :text
      add :thumbnail_mimetype, :string

      timestamps
    end

  end
end
