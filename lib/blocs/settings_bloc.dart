import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:trackaware_lite/database/database.dart';
import 'package:trackaware_lite/events/settings_event.dart';
import 'package:trackaware_lite/models/settings_db.dart';
import 'package:trackaware_lite/repositories/settings_repository.dart';
import 'package:trackaware_lite/states/settings_state.dart';
import 'package:trackaware_lite/utils/strings.dart';
import 'package:trackaware_lite/globals.dart' as globals;

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsPageApiRepository settingsPageApiRepository;

  SettingsBloc({
    @required this.settingsPageApiRepository,
  }) : assert(settingsPageApiRepository != null);

  @override
  SettingsState get initialState => SettingInitial();

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is TabsClick) {
      yield DisplayTabs();
    }

    if (event is ServerClick) {
      yield ServerClickSuccess();
    }

    if (event is LocationClick) {
      yield DisplayLocation();
    }

    if (event is TenderModeClick) {
      var insertSettings = DBProvider.db.insertSettings(event.settingsResponse);

      await insertSettings;

      yield TenderModeSuccess();
    }

    if (event is PickUpOnTenderClick) {
      var insertSettings = DBProvider.db.insertSettings(event.settingsResponse);

      await insertSettings;

      yield PickUpOnTenderSuccess();
    }

    if (event is DriverModeClick) {
      var insertSettings = DBProvider.db.insertSettings(event.settingsResponse);

      await insertSettings;

      yield DriverModeSuccess();
    }

    if (event is FetchUser) {
      var fetchUsers = await DBProvider.db.getUser();

      if (fetchUsers.isNotEmpty) {
        yield FetchUserSuccess(users: fetchUsers);
      }
    }

    if (event is ResetSettingEvent) {
      yield ResetSettingState();
    }

    if (event is FetchSettings) {
      var fetchSettings = await DBProvider.db.getSettings(event.userName);

      if (fetchSettings.isNotEmpty) {
        yield FetchSettingsSuccess(settings: fetchSettings);
      }
    }

    if (event is PriorityFetch) {
      yield SettingsLoading();
      try {
        final priorityResponse =
            await settingsPageApiRepository.fetchPriority();

        print(priorityResponse);

        if (priorityResponse is List) {
          await DBProvider.db.deletePriorityResponse();
          priorityResponse.forEach((element) async {
            await DBProvider.db.insertPriorityResponse(element);
          });

          yield PriorityResponseFetchSuccess(
              priorityResponse: priorityResponse);
        } else {
          yield PriorityResponseFetchFailure(
              error: Strings.PRIORITY_VALIDATION_MESSAGE);
        }
      } catch (error) {
        yield PriorityResponseFetchFailure(error: error.toString());
      }
    }

    if (event is LocationFetch) {
      yield SettingsLoading();
      try {
        final locationResponse =
            await settingsPageApiRepository.fetchLocation();

        print(locationResponse);

        if (locationResponse is List) {
          await DBProvider.db.deleteLocationResponse();
          locationResponse.forEach((element) async {
            await DBProvider.db.insertLocationResponse(element);
          });

          yield LocationResponseFetchSuccess(
              locationResponse: locationResponse);
        } else {
          yield LocationResponseFetchFailure(
              error: Strings.LOCATION_VALIDATION_MESSAGE);
        }
      } catch (error) {
        yield LocationResponseFetchFailure(error: error.toString());
      }
    }

    if (event is FetchAllDisciplineConfigValues) {
      var disciplineConfigValues =
          await DBProvider.db.fetchAllDisciplineConfig();

      if (disciplineConfigValues.isNotEmpty) {
        for (final DisciplineConfigResponse disciplineConfigValuesResponseItem
            in disciplineConfigValues) {
          switch (disciplineConfigValuesResponseItem.keyName) {
            case Strings.TENDER_PRODUCTION_PARTS_KEY:
              {
                globals.tenderProductionPartsDispName =
                    disciplineConfigValuesResponseItem.displayName;
              }
              break;
            case Strings.TENDER_EXTERNAL_PACKAGES_KEY:
              {
                globals.tenderExternalPackagesDispName =
                    disciplineConfigValuesResponseItem.displayName;
              }
              break;
            case Strings.PICKUP_PRODUCTION_PARTS_KEY:
              {
                globals.pickUpProductionPartsDispName =
                    disciplineConfigValuesResponseItem.displayName;
              }
              break;
            case Strings.PICKUP_EXTERNAL_PACKAGES_KEY:
              {
                globals.pickUpExternalPackagesDispName =
                    disciplineConfigValuesResponseItem.displayName;
              }
              break;
            case Strings.DEPART_KEY:
              {
                globals.departDispName =
                    disciplineConfigValuesResponseItem.displayName;
              }
              break;
            case Strings.ARRIVE_KEY:
              {
                globals.arriveDispName =
                    disciplineConfigValuesResponseItem.displayName;
              }
          }
        }
      }
    }
  }
}
