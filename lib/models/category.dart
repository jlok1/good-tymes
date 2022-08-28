List<Category> categories = [
  Category("sep", "Board Games", "default.png"),
  Category("Chess", "Board Games", "Chess.png"),
  Category("Cards", "Board Games", "Cards.png"),
  Category("Mahjong", "Board Games", "Mahjong.png"),
  Category("Sudoku", "Board Games", "Sudoku.png"),
  Category("Bingo", "Board Games", "Bingo.png"),
  Category("sep", "Mindful", "default.png"),
  Category("Taichi", "Mindful", "Taichi.png"),
  Category("Line Dancing", "Mindful", "Line Dancing.png"),
  Category("Yoga", "Mindful", "Yoga.png"),
  Category("Meditation", "Mindful", "Meditation.png"),
  Category("sep", "Nature", "default.png"),
  Category("Bird Feeding", "Nature", "Bird Feeding.png"),
  Category("Fish Feeding", "Nature", "Fish Feeding.png"),
  Category("Fishing", "Nature", "Fishing.png"),
  Category("Gardening", "Nature", "Gardening.png"),
];

String getPicture(String name) {
  String pic = "default.png";
  for (Category c in categories) {
    if (c.name == name) {
      return c.image;
    }
  }
  return pic;
}

class Category {
  Category(this.name, this.type, this.image);

  String name;
  String type;
  String image;
}
