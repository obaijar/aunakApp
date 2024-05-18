class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent(
      {required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'إدارة محتوى الدورة التعليمية',
      image: 'images/image 17.png',
      discription: " القدرة على إشارة أو حفظ الدورات للمشاهدة لاحقًا"
          "  وتتبع التقدم داخل كل دورة"),
  UnbordingContent(
      title: 'فهرس الدورات',
      image: 'images/image 19.png',
      discription: "تنظيم الدورات في فئات وفئات فرعية لتصفح سهل"),
  UnbordingContent(
      title: 'برنامج تعليمي', image: 'images/image2.png', discription: " "),
];
