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

  describe "words" do
    alias Gloss.Glossary.Word

    @valid_attrs %{def: "some def", word: "some word"}
    @update_attrs %{def: "some updated def", word: "some updated word"}
    @invalid_attrs %{def: nil, word: nil}

    def word_fixture(attrs \\ %{}) do
      {:ok, word} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Glossary.create_word()

      word
    end

    test "list_words/0 returns all words" do
      word = word_fixture()
      assert Glossary.list_words() == [word]
    end

    test "get_word!/1 returns the word with given id" do
      word = word_fixture()
      assert Glossary.get_word!(word.id) == word
    end

    test "create_word/1 with valid data creates a word" do
      assert {:ok, %Word{} = word} = Glossary.create_word(@valid_attrs)
      assert word.def == "some def"
      assert word.word == "some word"
    end

    test "create_word/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Glossary.create_word(@invalid_attrs)
    end

    test "update_word/2 with valid data updates the word" do
      word = word_fixture()
      assert {:ok, %Word{} = word} = Glossary.update_word(word, @update_attrs)
      assert word.def == "some updated def"
      assert word.word == "some updated word"
    end

    test "update_word/2 with invalid data returns error changeset" do
      word = word_fixture()
      assert {:error, %Ecto.Changeset{}} = Glossary.update_word(word, @invalid_attrs)
      assert word == Glossary.get_word!(word.id)
    end

    test "delete_word/1 deletes the word" do
      word = word_fixture()
      assert {:ok, %Word{}} = Glossary.delete_word(word)
      assert_raise Ecto.NoResultsError, fn -> Glossary.get_word!(word.id) end
    end

    test "change_word/1 returns a word changeset" do
      word = word_fixture()
      assert %Ecto.Changeset{} = Glossary.change_word(word)
    end
  end
end
