defmodule Melog.ExperiencesTest do
  use Melog.DataCase

  alias Melog.Experiences

  describe "experiences" do
    alias Melog.Experiences.Experience

    @valid_attrs %{intro: "some intro", title: "some title"}
    @update_attrs %{intro: "some updated intro", title: "some updated title"}
    @invalid_attrs %{intro: nil, title: nil}

    def experience_fixture(attrs \\ %{}) do
      {:ok, experience} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Experiences.create_experience()

      experience
    end

    test "list_experiences/0 returns all experiences" do
      experience = experience_fixture()
      assert Experiences.list_experiences() == [experience]
    end

    test "get_experience!/1 returns the experience with given id" do
      experience = experience_fixture()
      assert Experiences.get_experience!(experience.id) == experience
    end

    test "create_experience/1 with valid data creates a experience" do
      assert {:ok, %Experience{} = experience} = Experiences.create_experience(@valid_attrs)
      assert experience.intro == "some intro"
      assert experience.title == "some title"
    end

    test "create_experience/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Experiences.create_experience(@invalid_attrs)
    end

    test "update_experience/2 with valid data updates the experience" do
      experience = experience_fixture()
      assert {:ok, experience} = Experiences.update_experience(experience, @update_attrs)
      assert %Experience{} = experience
      assert experience.intro == "some updated intro"
      assert experience.title == "some updated title"
    end

    test "update_experience/2 with invalid data returns error changeset" do
      experience = experience_fixture()
      assert {:error, %Ecto.Changeset{}} = Experiences.update_experience(experience, @invalid_attrs)
      assert experience == Experiences.get_experience!(experience.id)
    end

    test "delete_experience/1 deletes the experience" do
      experience = experience_fixture()
      assert {:ok, %Experience{}} = Experiences.delete_experience(experience)
      assert_raise Ecto.NoResultsError, fn -> Experiences.get_experience!(experience.id) end
    end

    test "change_experience/1 returns a experience changeset" do
      experience = experience_fixture()
      assert %Ecto.Changeset{} = Experiences.change_experience(experience)
    end
  end

  describe "comments" do
    alias Melog.Experiences.Comment

    @valid_attrs %{text: "some text"}
    @update_attrs %{text: "some updated text"}
    @invalid_attrs %{text: nil}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Experiences.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Experiences.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Experiences.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Experiences.create_comment(@valid_attrs)
      assert comment.text == "some text"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Experiences.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, comment} = Experiences.update_comment(comment, @update_attrs)
      assert %Comment{} = comment
      assert comment.text == "some updated text"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Experiences.update_comment(comment, @invalid_attrs)
      assert comment == Experiences.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Experiences.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Experiences.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Experiences.change_comment(comment)
    end
  end

  describe "fields" do
    alias Melog.Experiences.Field

    @valid_attrs %{boolean: true, date: ~D[2010-04-17], date_time: "2010-04-17 14:00:00.000000Z", decimal: 120.5, multi_text: "some multi_text", name: "some name", number: 42, single_text: "some single_text"}
    @update_attrs %{boolean: false, date: ~D[2011-05-18], date_time: "2011-05-18 15:01:01.000000Z", decimal: 456.7, multi_text: "some updated multi_text", name: "some updated name", number: 43, single_text: "some updated single_text"}
    @invalid_attrs %{boolean: nil, date: nil, date_time: nil, decimal: nil, multi_text: nil, name: nil, number: nil, single_text: nil}

    def field_fixture(attrs \\ %{}) do
      {:ok, field} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Experiences.create_field()

      field
    end

    test "list_fields/0 returns all fields" do
      field = field_fixture()
      assert Experiences.list_fields() == [field]
    end

    test "get_field!/1 returns the field with given id" do
      field = field_fixture()
      assert Experiences.get_field!(field.id) == field
    end

    test "create_field/1 with valid data creates a field" do
      assert {:ok, %Field{} = field} = Experiences.create_field(@valid_attrs)
      assert field.boolean == true
      assert field.date == ~D[2010-04-17]
      assert field.date_time == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert field.decimal == 120.5
      assert field.multi_text == "some multi_text"
      assert field.name == "some name"
      assert field.number == 42
      assert field.single_text == "some single_text"
    end

    test "create_field/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Experiences.create_field(@invalid_attrs)
    end

    test "update_field/2 with valid data updates the field" do
      field = field_fixture()
      assert {:ok, field} = Experiences.update_field(field, @update_attrs)
      assert %Field{} = field
      assert field.boolean == false
      assert field.date == ~D[2011-05-18]
      assert field.date_time == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert field.decimal == 456.7
      assert field.multi_text == "some updated multi_text"
      assert field.name == "some updated name"
      assert field.number == 43
      assert field.single_text == "some updated single_text"
    end

    test "update_field/2 with invalid data returns error changeset" do
      field = field_fixture()
      assert {:error, %Ecto.Changeset{}} = Experiences.update_field(field, @invalid_attrs)
      assert field == Experiences.get_field!(field.id)
    end

    test "delete_field/1 deletes the field" do
      field = field_fixture()
      assert {:ok, %Field{}} = Experiences.delete_field(field)
      assert_raise Ecto.NoResultsError, fn -> Experiences.get_field!(field.id) end
    end

    test "change_field/1 returns a field changeset" do
      field = field_fixture()
      assert %Ecto.Changeset{} = Experiences.change_field(field)
    end
  end
end
