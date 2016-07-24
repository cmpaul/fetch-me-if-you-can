defmodule FetchMeIfYouCan.Repo.Migrations.CreateJob do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :job_id, :string
      add :content, :text
      add :status, :string

      timestamps
    end

  end
end
