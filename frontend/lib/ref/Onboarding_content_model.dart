class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent({required this.image,required this.title,required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Title 1',
      image: 'assets/Login/Onboard (1).png',
      discription: "Welcome to TravelEase! Discover destinations, plan "
          "trips, and book unforgettable experiences effortlessly. "
          "Start your adventure and explore the world with confidence!"
  ),
  UnbordingContent(
      title: 'Title 2',
      image: 'assets/Login/Onboard (2).png',
      discription: "Find your perfect getaway with TravelEase. From"
          " city tours to hidden gems, explore tailored recommendations"
          " and make every journey memorable. Begin your travel adventure today!"
  ),
  UnbordingContent(
      title: 'Title 3',
      image: 'assets/Login/Onboard (3).png',
      discription: "Your travel dreams, now within reach! Explore top"
          " destinations, get personalized tips, and connect with fellow travelers. "
          "Make planning easy with TravelEase and dive into new experiences."
  ),
];