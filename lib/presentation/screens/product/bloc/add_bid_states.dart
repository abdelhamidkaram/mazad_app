abstract class BidStates {}
class InitBidState extends BidStates {}
class GetBidController extends BidStates {}

class AddBidLoading extends BidStates {}
class AddBidSuccess extends BidStates {}
class AddBidError extends BidStates {}


class SendBidToServerLoading extends BidStates {}
class SendBidToServerSuccess extends BidStates {}
class SendBidToServerError extends BidStates {}

class DeleteNewPrice extends BidStates {}
