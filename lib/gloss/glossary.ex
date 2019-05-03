defmodule Gloss.Glossary do
  @moduledoc """
  The Glossary context.
  """

  import Ecto.Query, warn: false
  alias Gloss.Repo

  alias Gloss.Glossary.Section

  @doc """
  Returns the list of sections.

  ## Examples

      iex> list_sections()
      [%Section{}, ...]

  """
  def list_sections do
    Repo.all(Section, order_by: :name)
  end

  @doc """
  Gets a single section.

  Raises `Ecto.NoResultsError` if the Section does not exist.

  ## Examples

      iex> get_section!(123)
      %Section{}

      iex> get_section!(456)
      ** (Ecto.NoResultsError)

  """
  def get_section!(id), do: Repo.get!(Section, id)

  @doc """
  Creates a section.

  ## Examples

      iex> create_section(%{field: value})
      {:ok, %Section{}}

      iex> create_section(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_section(attrs \\ %{}) do
    rv =
    %Section{}
    |> Section.changeset(attrs)
    |> Repo.insert()

    notify_of_section_change()
    rv
  end

  @doc """
  Updates a section.

  ## Examples

      iex> update_section(section, %{field: new_value})
      {:ok, %Section{}}

      iex> update_section(section, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_section(%Section{} = section, attrs) do
    rv = section
    |> Section.changeset(attrs)
    |> Repo.update()

    notify_of_section_change()
    rv
  end

  @doc """
  Deletes a Section.

  ## Examples

      iex> delete_section(section)
      {:ok, %Section{}}

      iex> delete_section(section)
      {:error, %Ecto.Changeset{}}

  """
  def delete_section(%Section{} = section) do
    rv = Repo.delete(section)

    notify_of_section_change()
    rv
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking section changes.

  ## Examples

      iex> change_section(section)
      %Ecto.Changeset{source: %Section{}}

  """
  def change_section(%Section{} = section) do
    Section.changeset(section, %{})
  end


  defp notify_of_section_change() do
    Phoenix.PubSub.broadcast(Gloss.PubSub, "sections", :sections_changed)
  end

  alias Gloss.Glossary.Word

  @doc """
  Returns the list of words.

  ## Examples

      iex> list_words()
      [%Word{}, ...]

  """
  def list_words do
    Repo.all(Word)
  end

  def list_words(section, prefix \\ nil) do
    query = from w in Word,
              select: {w.id, w.word},
              where: w.section_id == ^section

    query = 
      if is_binary(prefix) do
        prefix = prefix <> "%"
        from w in query,
          where: ilike(w.word, ^prefix)
      else
        query
      end

    Repo.all(query)
  end

  @doc """
  Gets a single word.

  Raises `Ecto.NoResultsError` if the Word does not exist.

  ## Examples

      iex> get_word!(123)
      %Word{}

      iex> get_word!(456)
      ** (Ecto.NoResultsError)

  """
  def get_word!(id), do: Repo.get!(Word, id)

  @doc """
  Creates a word.

  ## Examples

      iex> create_word(%{field: value})
      {:ok, %Word{}}

      iex> create_word(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_word(attrs \\ %{}) do
    %Word{}
    |> Word.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a word.

  ## Examples

      iex> update_word(word, %{field: new_value})
      {:ok, %Word{}}

      iex> update_word(word, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_word(%Word{} = word, attrs) do
    word
    |> Word.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Word.

  ## Examples

      iex> delete_word(word)
      {:ok, %Word{}}

      iex> delete_word(word)
      {:error, %Ecto.Changeset{}}

  """
  def delete_word(%Word{} = word) do
    Repo.delete(word)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking word changes.

  ## Examples

      iex> change_word(word)
      %Ecto.Changeset{source: %Word{}}

  """
  def change_word(%Word{} = word) do
    Word.changeset(word, %{})
  end
end
