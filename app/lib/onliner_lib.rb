class OnlinerLib

  def self.get_minimal_price(primaries)
    minimal_price = []
    primaries.select do |primary|
      minimal_price << primary["position_price"]["amount"].to_f
    end

    [minimal_price.sort.try(:first), minimal_price.sort.try(:last)]
  end

end