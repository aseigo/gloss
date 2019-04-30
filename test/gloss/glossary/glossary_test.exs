defmodule Gloss.GlossaryTest do
  use Gloss.DataCase

  alias Gloss.Glossary

  describe "sections" do
    alias Gloss.Glossary.Section

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def section_fixture(attrs \\ %{}) do
      {:ok, section} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Glossary.create_section()

      section
    end

    test "list_sections/0 returns all sections" do
      section = section_fixture()
      assert Glossary.list_sections() == [section]
    end

    test "get_section!/1 returns the section with given id" do
      section = section_fixture()
      assert Glossary.get_section!(section.id) == section
    end

    test "create_section/1 with valid data creates a section" do
      assert {:ok, %Section{} = section} = Glossary.create_section(@valid_attrs)
      assert section.name == "some name"
    end

    test "create_section/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Glossary.create_section(@invalid_attrs)
    end

    test "update_section/2 with valid data updates the section" do
      section = section_fixture()
      assert {:ok, %Section{} = section} = Glossary.update_section(section, @update_attrs)
      assert section.name == "some updated name"
    end

    test "update_section/2 with invalid data returns error changeset" do
      section = section_fixture()
      assert {:error, %Ecto.Changeset{}} = Glossary.update_section(section, @invalid_attrs)
      assert section == Glossary.get_section!(section.id)
    end

    test "delete_section/1 deletes the section" do
      section = section_fixture()
      assert {:ok, %Section{}} = Glossary.delete_section(section)
      assert_raise Ecto.NoResultsError, fn -> Glossary.get_section!(section.id) end
    end

    test "change_section/1 returns a section changeset" do
      section = section_fixture()
      assert %Ecto.Changeset{} = Glossary.change_section(section)
    end
  end
end
