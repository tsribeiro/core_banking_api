defmodule CoreBanking.AccountBalance do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:account_balances_id, :id, autogenerate: true}
  schema "account_balances" do
    field(:create_at, :naive_datetime)
    field(:kind, :string)
    field(:amount, :integer)
    field(:account_id, :integer)
  end

  def create(kind, amount, account_id) do
    changeset(%CoreBanking.AccountBalance{}, %{
      "kind" => kind,
      "amount" => amount,
      "account_id" => account_id
    })
    |> CoreBanking.Repo.insert(timeout: 30_000)
  end

  defp changeset(struct, params) do
    struct
    |> cast(params, [:kind, :amount, :account_id])
    |> validate_required([:kind, :amount, :account_id])
  end

  def filter_by_account_id(account_id) do
    CoreBanking.Repo.all(
      from(ab in CoreBanking.AccountBalance,
        where: ab.account_id == ^account_id,
        select: %{kind: ab.kind, amount: ab.amount}
      ),
      timeout: 30_000
    )
  end
end
