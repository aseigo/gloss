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
    Gloss.PdfExporter.generate()
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
              where: w.section_id == ^section,
              order_by: w.word

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
    rv = %Word{}
         |> Word.changeset(attrs)
         |> Repo.insert()

    Gloss.PdfExporter.generate()
    rv
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
    rv = word
         |> Word.changeset(attrs)
         |> Repo.update()

    Gloss.PdfExporter.generate()
    rv
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

  def export(format \\ :pdf, section \\ -1)
  def export(:pdf, -1) do
    export_pdf(list_sections())
  end

  def export(:pdf, section) when is_number(section) do
    section = get_section!(section)
    export_pdf([section])
  end

  defp export_pdf(sections) do
    {:ok, path} =
      sections
      |> Enum.reduce("", &add_section_to_export/2)
      |> PdfGenerator.generate()

    path
  end

  defp add_section_to_export(section, html) do
    html = html <> ~s(<h2 style="text-decoration: underline;">#{section.name}</h2>)
    
    query = from w in Word,
              select: {w.word, w.def},
              where: w.section_id == ^section.id,
              order_by: w.word

    Repo.all(query)
    |> Enum.reduce(html, fn {term, def}, html -> html <> term_string(term, def) end)
  end

  defp term_string(term, def) do
    ~s(\n<div style="margin-top: 1em;"><strong>#{term}</strong><br/>#{def}</div>)
  end
end
