require './shared'

input = File.read('day21.input').strip.lines.map(&:chomp)

recipes = input.map do |line|
  line.split(' (contains ').map { _1.split(/[, )]+/) }
end

possible_ingredients_by_allergen = {}
recipes.each do |ingredients, allergens|
  allergens.each do |allergen|
    if possible_ingredients_by_allergen[allergen]
      possible_ingredients_by_allergen[allergen] &= ingredients
    else
      possible_ingredients_by_allergen[allergen] = ingredients
    end
  end
end

# Part 1

all_ingredients = recipes.map(&:first).reduce(:|)
bad_ingredients = possible_ingredients_by_allergen.values.reduce(:|)
good_ingredients = (all_ingredients - bad_ingredients).to_set

result_1 = recipes.flat_map(&:first).count { good_ingredients.include?(_1) }

puts result_1 # 2779

# Part 2

resolved_ingreds = Set.new
while (
  resolvable_ingredient = possible_ingredients_by_allergen
    .values
    .find_map do |ingreds|
      ingreds[0] if ingreds.length == 1 && !resolved_ingreds.include?(ingreds[0])
    end
)
  possible_ingredients_by_allergen.each_value do |ingreds|
    ingreds.delete(resolvable_ingredient) if ingreds.length > 1
  end
  resolved_ingreds.add(resolvable_ingredient)
end

result_2 = possible_ingredients_by_allergen
  .sort_by { |allr, _| allr }
  .map { |_, ingr| ingr }
  .join(',')

puts result_2 # lkv,lfcppl,jhsrjlj,jrhvk,zkls,qjltjd,xslr,rfpbpn
