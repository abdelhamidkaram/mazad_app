abstract class EditStates {}
class InitEditState extends EditStates {}

class GetImageState extends EditStates {}
class GetImageError extends EditStates {}
class SetImageState extends EditStates {}


class UploadSuccess  extends EditStates {}
class UploadError  extends EditStates {}