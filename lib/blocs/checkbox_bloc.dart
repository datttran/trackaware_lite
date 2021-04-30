import 'package:bloc/bloc.dart';
import 'package:trackaware_lite/events/checkbox_event.dart';
import 'package:trackaware_lite/states/checkbox_state.dart';

class CheckBoxBloc extends Bloc<CheckBoxEvent,CheckBoxState>{
  @override
  CheckBoxState get initialState => null;

  @override
  Stream<CheckBoxState> mapEventToState(CheckBoxEvent event) async*{
    
    if(event is CheckBoxClick){
        if(event.isChecked){
            yield CheckBoxChecked();
        }else{
          yield CheckBoxUnChecked();
        }
    }

  }

}