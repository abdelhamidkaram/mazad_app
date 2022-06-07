
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soom/presentation/screens/main_view/my_auctions/bloc/my_auctions_states.dart';

class MyAuctionsCubit extends Cubit<MyAuctionsStates>{
  MyAuctionsCubit() : super(InitAuctionState());

  static MyAuctionsCubit get(context) => BlocProvider.of(context);



}