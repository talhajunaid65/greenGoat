class RenameTableWishlistToFavourites < ActiveRecord::Migration[5.2]
  def change
    rename_table :wishlists, :favourites
  end
end
