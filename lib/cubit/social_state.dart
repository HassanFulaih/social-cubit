abstract class SocialStates {}

class SocialInitialStates extends SocialStates {}

class SocialBottomNavStatus extends SocialStates {}

class ThemeChangedState extends SocialStates {}

class SocialUserDataLoadingStatus extends SocialStates {}

class SocialUserDataSuccessStatus extends SocialStates {}

class SocialUserDataErrorStatus extends SocialStates {
  final String error;

  SocialUserDataErrorStatus(this.error);
}

class GetAllUserLoadingStatus extends SocialStates {}

class GetAllUserSuccessStatus extends SocialStates {}

class GetAllUserErrorStatus extends SocialStates {
  final String error;

  GetAllUserErrorStatus(this.error);
}

class SocialGetPostsLoadingStatus extends SocialStates {}

class SocialGetPostsSuccessStatus extends SocialStates {}

class SocialGetPostsErrorStatus extends SocialStates {
  final String error;

  SocialGetPostsErrorStatus(this.error);
}

class SocialProfileImgSuccessStatus extends SocialStates {}

class SocialCoverImgSuccessStatus extends SocialStates {}

class SocialPostImgSuccessStatus extends SocialStates {}

class SocialImageErrorStatus extends SocialStates {
  final String error;

  SocialImageErrorStatus(this.error);
}

class SocialLikePostLoadingStatus extends SocialStates {}

class SocialLikePostSuccessStatus extends SocialStates {}

class SocialLikePostErrorStatus extends SocialStates {
  final String error;

  SocialLikePostErrorStatus(this.error);
}

class SocialAddCommentLoadingStatus extends SocialStates {}

class SocialAddCommentSuccessStatus extends SocialStates {}

class SocialAddCommentErrorStatus extends SocialStates {
  final String error;

  SocialAddCommentErrorStatus(this.error);
}

class GetCommentDetailsLoadingStatus extends SocialStates {}

class GetCommentDetailsSuccessStatus extends SocialStates {}

class GetCommentDetailsErrorStatus extends SocialStates {
  final String error;

  GetCommentDetailsErrorStatus(this.error);
}

class UploadProfileImgLoadingStatus extends SocialStates {}

class UploadProfileImgSuccessStatus extends SocialStates {}

class UploadProfileImgErrorStatus extends SocialStates {
  final String error;

  UploadProfileImgErrorStatus(this.error);
}

class UploadCoverImgLoadingStatus extends SocialStates {}

class UploadCoverImgSuccessStatus extends SocialStates {}

class UploadCoverImgErrorStatus extends SocialStates {
  final String error;

  UploadCoverImgErrorStatus(this.error);
}

class UpdateLoadingStatus extends SocialStates {}

class UpdateSuccessStatus extends SocialStates {}

class UpdateErrorStatus extends SocialStates {
  final String error;

  UpdateErrorStatus(this.error);
}

class CreatePostLoadingStatus extends SocialStates {}

class CreatePostSuccessStatus extends SocialStates {}

class CreatePostErrorStatus extends SocialStates {
  final String error;

  CreatePostErrorStatus(this.error);
}

class RemoveProfileImgStatus extends SocialStates {}

class RemoveCoverImgStatus extends SocialStates {}

class RemovePostImgStatus extends SocialStates {}

// chat states
class SendMessageLoadingStatus extends SocialStates {}

class SendMessageSuccessStatus extends SocialStates {}

class SendMessageErrorStatus extends SocialStates {
  final String error;

  SendMessageErrorStatus(this.error);
}

class GetMessagesLoadingStatus extends SocialStates {}

class GetMessagesSuccessStatus extends SocialStates {}

class GetMessagesErrorStatus extends SocialStates {
  final String error;

  GetMessagesErrorStatus(this.error);
}

// get interaction states
class GetInteractionLoadingStatus extends SocialStates {}

class GetInteractionSuccessStatus extends SocialStates {}

class GetInteractionErrorStatus extends SocialStates {
  final String error;

  GetInteractionErrorStatus(this.error);
}
