// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers_platform_interface/src/api/player_state.dart'
    as playersState;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';
import 'package:gossip_go/features/chat/controller/chat_states.dart';
import 'package:gossip_go/features/chat/respositories/chat_repository.dart';
import 'package:gossip_go/features/providers/message_reply_provider/provider/message_reply_provider.dart';
import 'package:gossip_go/features/providers/message_reply_provider/provider/message_reply_states.dart';
import 'package:gossip_go/models/chat_contact_model.dart';
import 'package:gossip_go/models/group_model.dart';
import 'package:gossip_go/models/message_model.dart';
import 'package:gossip_go/utils/common_functions.dart';
import 'package:gossip_go/utils/messages_enum.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final chatNotifierProvider =
    NotifierProvider<ChatNotifer, ChatScreenStates>(ChatNotifer.new);

class ChatNotifer extends Notifier<ChatScreenStates> {
  //editing controller for chatText Field
  final TextEditingController messageTextController = TextEditingController();
  //filed focusNode
  final FocusNode textFieldFocusNode = FocusNode();
  //scrollcontroller for messages
  final ScrollController chatScrollController = ScrollController();
  //sound controller for audio Message
  late final FlutterSoundRecorder? _soundRecorder;
  //audio player controller
  final AudioPlayer _audioPlayer = AudioPlayer();
  //cached chatsContacts
  var chatContacts = <ChatContactModel>[];
  //cached messages
  var messages = <MessageModel>[];
  int count = 1;

  //!Video
  //should play video or not
  var shouldPlay = false;
  // video icon to display
  var videoIcon = Icons.play_circle_fill_outlined;
  //!Emoji
  // should display emojicontainer
  var shouldDisplayEmojis = false;
  var emojiIcon = Icons.emoji_emotions_outlined;
  //!Recording
  // is recorder initialized
  var isRecorderInitialized = false;
  // wether user is recording or not
  var isRecording = false;
  // wether audio is playing or not
  var isAudioPlaying = false;
  //audio duration
  var duration = Duration.zero;
  //current position of audio
  var audioPosition = Duration.zero;
  // audio icon to display
  var audioIcon = Icons.play_arrow_rounded;
  //chached groups
  var groupChats = <GroupModel>[];
  @override
  ChatScreenStates build() {
    _soundRecorder = FlutterSoundRecorder();
    _openAudioRecorder();
    _audioPlayer.onPlayerStateChanged.listen(
      (playerState) {
        state = ChatLoadingState();
        isAudioPlaying = playerState == playersState.PlayerState.playing;
        state = ChatLoadedState();
      },
    );
    _audioPlayer.onDurationChanged.listen(
      (newDuration) {
        state = ChatLoadingState();
        duration = newDuration;
        state = ChatLoadedState();
      },
    );

    _audioPlayer.onPositionChanged.listen(
      (position) {
        state = ChatLoadingState();
        audioPosition = position;
        state = ChatLoadedState();
      },
    );
    _audioPlayer.onPlayerComplete.listen(
      (event) {
        state = ChatLoadingState();
        duration = Duration.zero;
        audioPosition = Duration.zero;
        audioIcon = Icons.play_arrow_rounded;
        state = ChatLoadedState();
      },
    );
    ref.onDispose(
      () {
        messageTextController.dispose();
        chatScrollController.dispose();
        _soundRecorder!.closeRecorder();
        isRecorderInitialized = false;
      },
    );
    return ChatInitialState();
  }

  // this will get the latestMessage with the person we chatted
  Stream<List<ChatContactModel>> getContactsLatestChat() {
    return ref.read(chatRepositoryProvider).getChatContacts();
  }

  //this will get the groupsChat
  Stream<List<GroupModel>> getGroupChats() {
    return ref.read(chatRepositoryProvider).getGroupChats();
  }

  //this function will get the group info
  Future<GroupModel> groupDataById({required String groupId}) {
    return ref.read(chatRepositoryProvider).groupDataById(groupId: groupId);
  }

  // this will get the message of the receievr
  Stream<List<MessageModel>> getContactMessages({required String receiverId}) {
    return ref
        .read(chatRepositoryProvider)
        .getContactMessages(receiverId: receiverId);
  }

  // this will get the messages of the group
  Stream<List<MessageModel>> getGroupMessages({required String groupId}) {
    return ref.read(chatRepositoryProvider).getGroupMessages(groupId: groupId);
  }

  void dismissFocus(BuildContext context) {
    Focus.of(context).requestFocus(FocusNode());
  }

  //circle avatar icon
  IconData avatarIcon = Icons.mic;

  //text field function to cahnge icon
  String? onTextFieldValueChanged(String value) {
    state = ChatLoadingState();
    if (value.isNotEmpty) {
      avatarIcon = Icons.send;
    } else {
      avatarIcon = Icons.mic;
    }
    state = ChatLoadedState();
    return null;
  }

  void scrollToMaxPosition() {
    chatScrollController.jumpTo(chatScrollController.position.maxScrollExtent);
  }

  void sendTextMessage({
    required BuildContext context,
    required String groupOrReceiverId,
    required bool isGroupChat,
  }) {
    state = ChatLoadingState();
    var replyingMessageState = ref.read(messageReplyProvider);
    //if user is replying to a text then we will send the message reply otherwise null
    if (replyingMessageState is MessageReplyLoadedState) {
      //we donot know which user is sending message so we will call the method that we created to get current user data so we will call it and get the current user data
      ref.read(userProvider).whenData(
            (sender) => ref.read(chatRepositoryProvider).sendTextMessage(
                  context: context,
                  message: messageTextController.text.trim(),
                  sender: sender!,
                  groupOrReceiverId: groupOrReceiverId,
                  messageReply: replyingMessageState.messageReply,
                  isGroupChat: isGroupChat,
                ),
          );
      ref.read(messageReplyProvider.notifier).changeState();
    } else {
      ref.read(userProvider).whenData(
            (sender) => ref.read(chatRepositoryProvider).sendTextMessage(
                  context: context,
                  message: messageTextController.text.trim(),
                  sender: sender!,
                  groupOrReceiverId: groupOrReceiverId,
                  messageReply: null,
                  isGroupChat: isGroupChat,
                ),
          );
    }

    avatarIcon = Icons.mic;
    messageTextController.clear();
    chatScrollController.jumpTo(chatScrollController.position.maxScrollExtent);
    state = ChatLoadedState();
  }

  // this message will send image aur video or auido based on the type
  void sendFileMessage({
    required BuildContext context,
    required String groupOrReceiverId,
    required MessageEnum messageType,
    String? audioPath,
    required bool isGroupChat,
  }) async {
    log('Audio Path : $audioPath');
    File? file = switch (messageType) {
      MessageEnum.image => await pickImageFromGallery(context: context),
      MessageEnum.video => await pickVideoFromGallery(context: context),
      _ => File(audioPath!),
    };

    // if selected file is not equal to null only then we will send data to firestore
    if (file != null) {
      file.createSync();
      // bool exists = await file.exists();
      // log('File Exists : $exists');
      var replyingState = ref.read(messageReplyProvider);
      if (replyingState is MessageReplyLoadedState) {
        ref.read(userProvider).whenData(
              (senderUser) => ref.read(chatRepositoryProvider).sendFileMessage(
                    context: context,
                    file: file,
                    receiverUserId: groupOrReceiverId,
                    senderUserData: senderUser!,
                    ref: ref,
                    messageType: messageType,
                    messageReply: replyingState.messageReply,
                    isGroupChat: isGroupChat,
                  ),
            );
        ref.read(messageReplyProvider.notifier).changeState();
      } else {
        ref.read(userProvider).whenData(
              (senderUser) => ref.read(chatRepositoryProvider).sendFileMessage(
                    context: context,
                    file: file,
                    receiverUserId: groupOrReceiverId,
                    senderUserData: senderUser!,
                    ref: ref,
                    messageType: messageType,
                    messageReply: null,
                    isGroupChat: isGroupChat,
                  ),
            );
      }
    }
  }

  // this message will send the Gif
  void sendGifMessage({
    required BuildContext context,
    required String groupOrReceiverId,
    required bool isGroupChat,
  }) async {
    final gif = await pickGif(context: context);
    if (gif != null) {
      //to display the gif, the url provided by the the message will not work so we have to convert it to the url that will work and show the gif, we will extract the lst part after the hyphen that is the code of the gif and place it with the basUrl.
      var replyingState = ref.read(messageReplyProvider);
      const baseUrl = 'https://i.giphy.com/media/';
      final gifCodeIndex = gif.url.lastIndexOf('-') + 1;
      final gifCode = gif.url.substring(gifCodeIndex);
      final gifUrl = '$baseUrl$gifCode/200.gif';
      if (replyingState is MessageReplyLoadedState) {
        ref.read(userProvider).whenData(
              (sender) => ref.read(chatRepositoryProvider).sendGifMessage(
                    context: context,
                    gifUrl: gifUrl,
                    sender: sender!,
                    messageReceiverId: groupOrReceiverId,
                    messageReply: replyingState.messageReply,
                    isGroupChat: isGroupChat,
                  ),
            );
        ref.read(messageReplyProvider.notifier).changeState();
      } else {
        ref.read(userProvider).whenData(
              (sender) => ref.read(chatRepositoryProvider).sendGifMessage(
                    context: context,
                    gifUrl: gifUrl,
                    sender: sender!,
                    messageReceiverId: groupOrReceiverId,
                    messageReply: null,
                    isGroupChat: isGroupChat,
                  ),
            );
      }
    }
  }

  // show the emoji in the text field
  void onEmojiSelected(Category? category, Emoji emoji) {
    state = ChatLoadingState();
    messageTextController.text = messageTextController.text + emoji.emoji;
    avatarIcon = Icons.send;
    state = ChatLoadedState();
  }

  // exchanging the keyboard and emoji icon
  void onEmojiIconTap() {
    state = ChatLoadingState();
    if (shouldDisplayEmojis) {
      textFieldFocusNode.requestFocus();
      shouldDisplayEmojis = false;
      emojiIcon = Icons.emoji_emotions_outlined;
    } else {
      textFieldFocusNode.unfocus();
      shouldDisplayEmojis = true;
      emojiIcon = Icons.keyboard_alt_outlined;
    }
    state = ChatLoadedState();
  }

  // to initialize recorder
  void _openAudioRecorder() async {
    final permission = await Permission.microphone.request();
    if (permission != PermissionStatus.granted) {
    } else {
      _soundRecorder!.openRecorder();
      isRecorderInitialized = true;
    }
  }

  // sendAudioMessage
  void sendAudioMessage({
    required BuildContext context,
    required String groupOrReceiverId,
    required bool isGroupChat,
  }) async {
    if (!isRecorderInitialized) {
      // if there is some kind of issue return without doing anything
      return;
    }
    state = ChatLoadingState();
    //in the start recorder function we need to give the directory or path to where we want to store the recording
    var tempDir = await getTemporaryDirectory();
    var recordingPath = '${tempDir.path}/flutter_audio_recordings.aac';
    count++;
    if (isRecording) {
      await _soundRecorder!.stopRecorder();
      sendFileMessage(
        context: context,
        groupOrReceiverId: groupOrReceiverId,
        messageType: MessageEnum.audio,
        audioPath: recordingPath,
        isGroupChat: isGroupChat,
        //group chat ki databse smjhni hay
      );
      avatarIcon = Icons.mic;
    } else {
      await _soundRecorder!.startRecorder(
        toFile: recordingPath,
      );
      avatarIcon = Icons.close;
    }
    isRecording = !isRecording;
    state = ChatLoadedState();
  }

  void onAudioIconTap({required String audioSource}) async {
    state = ChatLoadingState();
    if (isAudioPlaying) {
      audioIcon = Icons.play_arrow_rounded;
      _audioPlayer.pause();
      isAudioPlaying = false;
    } else {
      audioIcon = Icons.pause_rounded;
      _audioPlayer.play(UrlSource(audioSource));
      isAudioPlaying = true;
    }
    state = ChatLoadedState();
  }

  //slider position
  void onSliderChange(double value) {
    final pos = Duration(seconds: value.toInt());
    _audioPlayer.seek(pos);
    _audioPlayer.resume();
  }

  //this function will set/update the existing message is seen property to seen
  void setChatMessageSeen({
    required BuildContext context,
    required String receiverUserId,
    required String messageId,
  }) {
    ref.read(chatRepositoryProvider).setChatMessageToSeen(
        context: context, receiverUserId: receiverUserId, messageId: messageId);
  }
}
