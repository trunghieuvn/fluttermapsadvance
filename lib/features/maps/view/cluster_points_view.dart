import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermapsadvance/core/network/network_manager.dart';
import 'package:fluttermapsadvance/features/maps/cubit/cluster/cluster_cubit.dart';
import 'package:fluttermapsadvance/features/maps/cubit/cluster/cluster_state.dart';
import 'package:fluttermapsadvance/features/maps/model/cluster_coordinate.dart';
import 'package:fluttermapsadvance/features/maps/service/IMapService.dart';
import 'package:fluttermapsadvance/features/maps/service/maps_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClusterPointsView extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  IMapService get mapService =>
      MapService(NetworkManager.instance.service, scaffoldKey);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClusterCubit(mapService),
      child: Scaffold(
        body: BlocConsumer<ClusterCubit, ClusterState>(
          listener: (context, state) {},
          builder: (context, state) {
            switch (state.runtimeType) {
              case ClusterInitial:
                context.read<ClusterCubit>().fetchAllPoints();
                return buildCenterLoading;
              case ClusterCompleted:
                return clusterMapView((state as ClusterCompleted).coordinate);
              default:
                return buildCenterLoading;
            }
          },
        ),
      ),
    );
  }

  Center get buildCenterLoading => Center(child: CircularProgressIndicator());

  Widget clusterMapView(ClusterCoordinate cluster) {
    return GoogleMap(
      markers: Set.from(cluster.coordinates.map(
        (item) => Marker(
          markerId: MarkerId(item.coordinate.toString()),
          position: item.coordinate,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        ),
      )),
      initialCameraPosition:
          CameraPosition(target: cluster.coordinates.first.coordinate),
    );
  }
}