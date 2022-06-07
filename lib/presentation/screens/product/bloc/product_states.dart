abstract class BidStates {}
class InitBidState extends BidStates {}
class GetBidController extends BidStates {}

class AddBid extends BidStates {}
class AddBidError extends BidStates {}

class RemoveBid extends BidStates {}
class RemoveBidError extends BidStates {}