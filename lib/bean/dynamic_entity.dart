class DynamicEntity {

  // "target_title" : "非友人关系",
  // "action_type" : 2,
  // "target_id" : 2957,
  // "target_str" : "非友人关系",
  // "hot_word_source" : "机器",
  // "description" : "17920",
  // "background_image_url" : "https://tn1-f2.kkmh.com/image/211227/nvdhvOQRl.webp-w750",
  // "heat_count" : 17920


   String title;
   String source;
   String imageUrl;
   // var count;
   // var id;

   int count;

































   int id;

  DynamicEntity.fromMap(Map<String, dynamic> map){
    title = map['target_title'];
    source = map['hot_word_source'];
    imageUrl = map['background_image_url'];
    count = map['heat_count'];
    id = map['target_id'];

  }
}
