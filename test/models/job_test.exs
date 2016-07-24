defmodule FetchMeIfYouCan.JobTest do
  use FetchMeIfYouCan.ModelCase

  alias FetchMeIfYouCan.Job

  @valid_attrs %{content: "some content", job_id: "some content", status: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Job.changeset(%Job{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Job.changeset(%Job{}, @invalid_attrs)
    refute changeset.valid?
  end
end
