import 'package:flutter/material.dart';

void main() {
  runApp(RecipeApp());
}
class RecipeApp extends StatefulWidget {
  @override
  _RecipeAppState createState() => _RecipeAppState();
}

class _RecipeAppState extends State<RecipeApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "M's Recipe App",

      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),


      home: RecipeListScreen(
        toggleTheme: _toggleTheme,
      ),
    );
  }
}

class RecipeListScreen extends StatelessWidget {
  final List<Recipe> recipes;
  final VoidCallback toggleTheme;

  RecipeListScreen({Key? key, required this.toggleTheme})
      : recipes = List.from(dummyRecipes),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Recipes'),


        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,

                delegate: RecipeSearchDelegate(recipes: recipes),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to the home page or perform any other action you want
              },
            ),
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  toggleTheme();
                },
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(recipe: recipe),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Image.asset(
                        recipe.image,
                        fit: BoxFit.cover,
                        height: 200.0,
                        width: double.infinity,
                      ),
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                          ),
                        ),
                        child: Text(
                          recipe.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}



class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              recipe.image,
              fit: BoxFit.cover,
              height: 200.0,
              width: double.infinity,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ingredients:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    recipe.ingredients,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Instructions:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    recipe.instructions,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Recipe {
  final String name;
  final String ingredients;
  final String instructions;
  final String image;

  Recipe({
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.image,
  });
}
class RecipeSearchDelegate extends SearchDelegate<Recipe> {
  final List<Recipe> recipes;
  final List<Recipe> _searchResults = [];

  RecipeSearchDelegate({required this.recipes});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _searchResults.clear();
    _searchResults.addAll(recipes.where((recipe) =>
        recipe.name.toLowerCase().contains(query.toLowerCase())));
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final recipe = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(recipe: recipe),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Image.asset(
                      recipe.image,
                      fit: BoxFit.cover,
                      height: 200.0,
                      width: double.infinity,
                    ),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                        ),
                      ),
                      child: Text(
                        recipe.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return ListTile(
          title: Text(recipe.name),
          onTap: () {
            query = recipe.name;
            showResults(context);
          },
        );
      },
    );
  }
}


final List<Recipe> dummyRecipes = [
  Recipe(
    name: 'Pasta Carbonara',
    ingredients: 'Spaghetti, eggs, bacon, parmesan cheese, black pepper',
    instructions:
    '1. Cook spaghetti until al dente...\n2. Fry bacon until crispy...\n3. Beat eggs and mix with parmesan cheese and black pepper...\n4. Combine cooked spaghetti, bacon, and egg mixture...',
    image: 'lib/asset/pasta.jpeg',
  ),
  Recipe(
    name: 'Chicken Stir Fry',
    ingredients:
    'Chicken breast, soy sauce, garlic, ginger, vegetables (e.g., bell peppers, broccoli, carrots)',
    instructions:
    '1. Slice chicken breast into strips...\n2. Marinate chicken in soy sauce, garlic, and ginger...\n3. Stir fry vegetables in a hot pan...\n4. Add chicken and cook until done...',
    image: 'lib/asset/Chicken_stir_fry.jpeg',
  ),
  Recipe(
    name: 'Chocolate Chip Cookies',
    ingredients:
    'Flour, sugar, butter, eggs, chocolate chips, baking soda, vanilla extract',
    instructions:
    '1. Cream together butter and sugar until light and fluffy...\n2. Beat in eggs and vanilla extract...\n3. Mix in flour, baking soda, and chocolate chips...\n4. Drop spoonfuls of dough onto baking sheet and bake...',
    image: 'lib/asset/cookies.jpeg',
  ),
  // Add more recipes here...
  Recipe(
    name: 'Biryani',
    ingredients:
    'Rice, chicken, yogurt, onions, tomatoes, spices, saffron, nuts',
    instructions:
    '1. Marinate chicken in yogurt and spices...\n2. Cook rice until partially done...\n3. Layer rice and chicken in a pot...\n4. Cook until rice and chicken are fully done...\n5. Garnish with fried onions, tomatoes, and nuts...',
    image: 'lib/asset/bryani.jpeg',
  ),
  Recipe(
    name: 'Vanilla Milkshake',
    ingredients: 'Vanilla ice cream, milk, sugar, whipped cream',
    instructions:
    '1. Blend vanilla ice cream, milk, and sugar until smooth...\n2. Pour into a glass...\n3. Top with whipped cream...',
    image: 'lib/asset/shake.jpeg',
  ),
  Recipe(
    name: 'Gulab Jamun',
    ingredients: 'Milk powder, flour, ghee, sugar, cardamom, rose water',
    instructions:
    '1. Mix milk powder, flour, and ghee to make dough...\n2. Shape into balls and fry until golden brown...\n3. Make sugar syrup with water, sugar, cardamom, and rose water...\n4. Soak fried balls in sugar syrup...',
    image: 'lib/asset/gulamjamun.jpeg',
  ),
  Recipe(
    name: 'Daal Chawal',
    ingredients: 'Lentils, rice, onions, tomatoes, garlic, ginger, spices',
    instructions:
    '1. Cook lentils until soft and mushy...\n2. Cook rice until done...\n3. Saute onions, garlic, and ginger until golden brown...\n4. Add tomatoes and spices and cook until tomatoes are soft...\n5. Serve lentils and rice with the onion-tomato gravy...',
    image: 'lib/asset/dalchawal.jpeg',
  ),
  Recipe(
    name: 'Garlic Bread',
    ingredients:
    'Bread, garlic, butter, parsley, cheese (optional), salt, pepper',
    instructions:
    '1. Mix softened butter with minced garlic, chopped parsley, salt, and pepper...\n2. Cut bread into slices...\n3. Spread garlic butter mixture on bread slices...\n4. Optionally, sprinkle cheese on top...\n5. Bake in preheated oven until golden brown and crispy...',
    image: 'lib/asset/garlicbread.jpeg',
  ),
  Recipe(
    name: 'Pizza',
    ingredients:
    'Pizza dough, tomato sauce, mozzarella cheese, toppings (e.g., pepperoni, mushrooms, bell peppers)',
    instructions:
    '1. Roll out pizza dough into desired shape...\n2. Spread tomato sauce evenly on the dough...\n3. Sprinkle shredded mozzarella cheese...\n4. Add desired toppings...\n5. Bake in preheated oven until crust is golden brown and cheese is melted and bubbly...',
    image: 'lib/asset/pizza.jpeg',
  ),
  Recipe(
    name: 'White Sauce Spaghetti',
    ingredients:
    'Spaghetti, milk, butter, flour, garlic, parmesan cheese, salt, pepper',
    instructions:
    '1. Cook spaghetti until al dente...\n2. In a separate pan, melt butter and saute minced garlic...\n3. Add flour and cook until lightly golden...\n4. Gradually add milk while stirring continuously to avoid lumps...\n5. Season with salt and pepper...\n6. Add cooked spaghetti and parmesan cheese...\n7. Toss until spaghetti is coated evenly with the sauce...',
    image: 'lib/asset/whita_pasta.jpeg',
  ),
  Recipe(
    name: 'White Chicken Karhai',
    ingredients:
    'Chicken, yogurt, onions, tomatoes, ginger, garlic, green chilies, cream, spices',
    instructions:
    '1. Marinate chicken in yogurt and spices...'
        '\n2. In a karhai, heat oil and saute onions, ginger, garlic, and green chilies until golden brown...\'n3. Add tomatoes and cook until soft...\n4. Add marinated chicken and cook until done...'
        '\n5. Finish with a splash of cream...\n6. Garnish with fresh coriander leaves and ginger julienne...',
    image: 'lib/asset/whitekarhai.jpeg',
  ),
  Recipe(
    name: 'Club Sandwich',
    ingredients:
    'Bread slices, chicken breast, lettuce, tomatoes, cucumber, cheese, mayonnaise, mustard sauce',
    instructions:
    '1. Cook chicken breast until done and slice thinly...\n2. Toast bread slices until lightly golden...'
        '\n3. Spread mayonnaise and mustard sauce on one side of each slice...'
        '\n4. Layer chicken slices, lettuce, tomatoes, cucumber, and cheese...'
        '\n5. Top with another slice of bread...\n6. Cut diagonally and serve with fries and ketchup...',
    image: 'lib/asset/club_sandwitch.jpeg',
  ),
];
