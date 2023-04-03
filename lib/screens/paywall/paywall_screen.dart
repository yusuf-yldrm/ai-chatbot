// ignore_for_file: prefer_final_fields, library_private_types_in_public_api
import 'package:flutter/material.dart';

class PaywallPage extends StatefulWidget {
  const PaywallPage({Key? key}) : super(key: key);

  @override
  _PaywallPageState createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  List<SubscriptionPlan> _subscriptionPlans = [
    SubscriptionPlan(name: 'Basic', price: '4.99', duration: '1 month'),
    SubscriptionPlan(name: 'Premium', price: '9.99', duration: '6 months'),
    SubscriptionPlan(name: 'Pro', price: '19.99', duration: '1 year'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscribe'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a subscription plan:',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _subscriptionPlans.length,
                itemBuilder: (BuildContext context, int index) {
                  return SubscriptionPlanWidget(
                      subscriptionPlan: _subscriptionPlans[index]);
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement subscription purchase flow
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 32.0,
                ),
                child: Text(
                  'Subscribe',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            TextButton(
              onPressed: () {
                // TODO: Implement restore purchases flow
              },
              child: Text(
                'Restore purchases',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionPlan {
  final String name;
  final String price;
  final String duration;

  SubscriptionPlan(
      {required this.name, required this.price, required this.duration});
}

class SubscriptionPlanWidget extends StatelessWidget {
  final SubscriptionPlan subscriptionPlan;

  const SubscriptionPlanWidget({Key? key, required this.subscriptionPlan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Colors.grey[300]!,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subscriptionPlan.name,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Text(
            '\$${subscriptionPlan.price} / ${subscriptionPlan.duration}',
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}
