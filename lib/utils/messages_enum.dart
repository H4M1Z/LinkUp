enum MessageEnum {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  const MessageEnum(this.type);
  final String type;
}

extension EnumConversion on String {
  MessageEnum toEnum() => switch (this) {
        'text' => MessageEnum.text,
        'image' => MessageEnum.image,
        'audio' => MessageEnum.audio,
        'video' => MessageEnum.video,
        _ => MessageEnum.gif,
      };
}
