import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:chefaa/core/resources/color_manager.dart';
import 'package:chefaa/core/resources/styles_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/features/patient/order/data/models/orders_list_response.dart';
import 'package:chefaa/features/patient/order/presentation/widgets/order_list_card.dart';

class OrdersListPage extends StatefulWidget {
  const OrdersListPage({super.key});

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['All', 'Active', 'Delivered', 'Cancelled'];

  // Dummy Data for UI Preview
  final List<OrderSummaryItem> _dummyOrders = [
    OrderSummaryItem(
      id: '1',
      orderNumber: '1001',
      status: 'On The Way',
      totalPrice: 250.50,
      paymentMethod: 'Cash',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      itemsCount: 3,
      pharmacyName: 'El-Ezaby Pharmacy',
    ),
    OrderSummaryItem(
      id: '2',
      orderNumber: '1002',
      status: 'Preparing',
      totalPrice: 120.00,
      paymentMethod: 'Credit Card',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
      itemsCount: 1,
      pharmacyName: 'Seif Pharmacy',
    ),
    OrderSummaryItem(
      id: '3',
      orderNumber: '1003',
      status: 'Delivered',
      totalPrice: 450.00,
      paymentMethod: 'Cash',
      createdAt: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      itemsCount: 5,
      pharmacyName: 'Roshdy Pharmacy',
    ),
    OrderSummaryItem(
      id: '4',
      orderNumber: '1004',
      status: 'Cancelled',
      totalPrice: 85.00,
      paymentMethod: 'Credit Card',
      createdAt: DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      itemsCount: 2,
      pharmacyName: 'El-Tartoushy Pharmacy',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightGray,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 140.h,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: ColorManager.primary,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: ColorManager.white,
                size: 22.sp,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xff0065A3), Color(0xff0087D4)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        48.verticalSpace,
                        Text(
                          'My Orders',
                          style: getBoldStyle(
                            color: ColorManager.white,
                            fontSize: 26.sp,
                          ),
                        ),
                        6.verticalSpace,
                        Text(
                          'Track and manage your pharmacy orders',
                          style: getMediumStyle(
                            color: ColorManager.white.withAlpha(190),
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48.h),
              child: Container(
                color: ColorManager.primary,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: ColorManager.white,
                  indicatorWeight: 3,
                  labelColor: ColorManager.white,
                  unselectedLabelColor: ColorManager.white.withAlpha(150),
                  labelStyle: getSemiBoldStyle(
                    fontSize: 13.sp,
                    color: ColorManager.black,
                  ),
                  unselectedLabelStyle: getMediumStyle(
                    fontSize: 13.sp,
                    color: ColorManager.black,
                  ),
                  tabs: _tabs.map((t) => Tab(text: t)).toList(),
                  onTap: (_) => setState(() {}),
                ),
              ),
            ),
          ),
        ],
        body: Builder(
          builder: (context) {
            final allOrders = _dummyOrders;

            // Filter by selected tab
            final tabIndex = _tabController.index;
            final filtered = tabIndex == 0
                ? allOrders
                : allOrders.where((o) {
                    final s = o.status.toLowerCase();
                    if (tabIndex == 1) {
                      // Active = not delivered, not cancelled
                      return s != 'delivered' &&
                          s != 'cancelled' &&
                          s != 'canceled';
                    } else if (tabIndex == 2) {
                      return s == 'delivered';
                    } else {
                      return s == 'cancelled' || s == 'canceled';
                    }
                  }).toList();

            if (filtered.isEmpty) {
              return _EmptyOrders(tab: _tabs[tabIndex]);
            }

            return RefreshIndicator(
              color: ColorManager.primary,
              onRefresh: () async {
                // Dummy refresh delay
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 20.h,
                ),
                itemCount: filtered.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final order = filtered[index];
                  return OrderListCard(
                    order: order,
                    onTrack: () {
                      context.push(AppRoutesNames.trackOrderPage.replaceFirst(':orderId', order.id.toString()));
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  final String tab;

  const _EmptyOrders({required this.tab});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: ColorManager.lightBlue.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                size: 56.sp,
                color: ColorManager.primary.withValues(alpha: 0.6),
              ),
            ),
            28.verticalSpace,
            Text(
              tab == 'All' ? 'No orders yet' : 'No $tab orders',
              style: getBoldStyle(color: ColorManager.black, fontSize: 20.sp),
            ),
            12.verticalSpace,
            Text(
              tab == 'All'
                  ? 'Your orders will appear here once you place one.'
                  : 'You don\'t have any ${tab.toLowerCase()} orders at the moment.',
              style: getRegularStyle(color: ColorManager.gray, fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
