import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:use/components/purchase_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:use/helpers/data_store.dart';
import 'dart:async';

import 'package:use/models/paywall.dart';
import 'package:use/models/product.dart';

class PaywallPage extends StatefulWidget {

  final Paywall paywall;

  const PaywallPage({ 
    Key? key,
    required this.paywall,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PaywallPageState();
}

class PaywallPageState extends State<PaywallPage> with SingleTickerProviderStateMixin {
  
  // Properties

  late AnimationController controller;

  late Product? selectedProduct = widget.paywall.platforms.android?.first;

  Timer? timer;
  bool dismissIsActive = false;
  bool get loading { return purchasing || restoring; }
  bool purchasing = false;
  bool restoring = false;

  // Life Cycle

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: Provider.of<DataStore>(context, listen: false).inReview ? 0 : 1
      ),
    );

    startTimer();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  // View

  @override
  Widget build(BuildContext context) {
    return Consumer<DataStore>(
      builder: (context, dataStore, child) => Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 100),
    
                Center(
                  child: SizedBox(
                    height: 100, 
                    width: MediaQuery.of(context).size.width - 72,
                    child: Image(
                      image: AssetImage("resources/images/paywall_cover.png"), 
                      fit: BoxFit.fitWidth,
                      height: 100,
                      width: MediaQuery.of(context).size.width - 72,
                    ),
                  ),
                ),
    
                Spacer()
              ]
            ),
    
            Column(children: [
              Row(children: [
                Spacer(),
    
                Padding(
                  padding: EdgeInsets.only(top: 40, right: 16),
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (_, child) {
                      return Opacity(
                        opacity: controller.value, 
                        child: child
                      );
                    },
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey[400], 
                        size: 30
                      ),
                      onPressed: () {
                        if (dismissIsActive) {
                          Get.back();
                        }
                      },
                    ),
                  ),
                )
              ]),
  
              Spacer(),
          
              Center(
                child: Text(
                  "Unlock All Features",
                  style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
                ),
              ),
          
              SizedBox(height: 15),
            
              Text(
                "Use GPT-3 and DALL·E 2",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15, 
                  fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              ),
          
              SizedBox(height: 40),
            
              Padding(
                    padding: EdgeInsets.only(left: 16, right: 16), 
                    child: ListView.builder(
                      itemCount: widget.paywall.platforms.android?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        var myProductList = widget.paywall.platforms.android?.toList() ?? [];
                        return Column(children: [
                          PurchaseButton(
                            title: myProductList[index].leftText ?? "",
                            description: myProductList[index].rightText ?? "",
                            isSelected: ValueNotifier<bool>(selectedProduct == myProductList[index]),
                            onPressed: () async {
                              if (loading) return;
                        
                              var myProductList = widget.paywall.platforms.android?.toList() ?? [];
                        
                              if (dataStore.inReview) {
                                setState(() {
                                  selectedProduct = myProductList[index];
                                });  
                        
                                return;
                              }
                        
                              setState(() {
                                selectedProduct = myProductList[index];
                                purchasing = true;
                              });
                                      
                              final offerings = await Purchases.getOfferings();
                              final package = offerings.current?.availablePackages.firstWhere(
                                (package) => package.identifier == myProductList[index].productId
                              );
                                      
                              if (package != null) {
                                try {
                                  final purchaserInfo = await Purchases.purchasePackage(package);
                                  dataStore.hasPermission = purchaserInfo.entitlements.all["premium"]?.isActive == true;
                                  if (dataStore.hasPermission) {
                                    Navigator.pop(context); 
                                  }
                                } on PlatformException catch (e) {
                                  var errorCode = PurchasesErrorHelper.getErrorCode(e);
                                  if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
                                  } else {
                                    setState(() {
                                      purchasing = false;
                                    });
                                  }
                                }
                              }
                        
                              setState(() {
                                purchasing = false;
                              });
                            }
                          ),

                          SizedBox(height: 15),
                        ]);
                      },
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                    )
              ),
  
              SizedBox(height: 40),
    
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 65,
                child: ElevatedButton(
                  onPressed: () async {
                    if (loading) {
                      return;
                    }

                    setState(() {
                      purchasing = true;
                    });
          
                    final offerings = await Purchases.getOfferings();
          
                    final package = offerings.current?.availablePackages.firstWhere(
                      (package) => package.identifier == selectedProduct?.productId
                    );
          
                    if (package != null) {
                      try {
                        final purchaserInfo = await Purchases.purchasePackage(package);
                        dataStore.hasPermission = purchaserInfo.entitlements.all["premium"]?.isActive == true;

                        if (dataStore.hasPermission) {
                          Navigator.pop(context);
                        }
                      } on PlatformException catch (e) {
                        var errorCode = PurchasesErrorHelper.getErrorCode(e);
                        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
                        } else {
                          setState(() {
                            purchasing = false;
                          });
                        }
                      }
                    }
          
                    setState(() {
                      purchasing = false;
                    });
                  },
                  child: purchasing 
                    ? 
                      CupertinoActivityIndicator(color: Colors.black)
                    : 
                      Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              ),
        
              SizedBox(height: 32),
          
              RichText(
                text: TextSpan(
                  text: "Cancel Anytime,",
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' we’ll still love you',
                      style: TextStyle(
                        color: Colors.grey, fontSize: 14
                      ),
                    )
                  ]
                ),
              ),
        
              SizedBox(height: 12),
        
              ElevatedButton(
                onPressed: () async {
                  if (loading) return;

                  setState(() {
                    restoring = true;
                  });
  
                  final purchaserInfo = await Purchases.restorePurchases();
                  var isPremium = purchaserInfo.entitlements.all['premium']?.isActive == true;
  
                  if (isPremium) {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    dataStore.hasPermission = isPremium;
                    await prefs.setBool('has_permission', true);
                    Get.back();
                  } else {
                    Get.snackbar(
                      "You're not subscribed",
                      'No active subscriptions found.',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
  
                  setState(() {
                    restoring = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child:
                restoring 
                  ?
                    CupertinoActivityIndicator()
                  :
                    Text(
                      "Restore Purchase",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        backgroundColor: Colors.transparent,
                      )
                    )
              ),
          
              SizedBox(height: 30),
            ]),
          ],
        ),
      ),
    );
  }

  // Methods

  void startTimer() {
    final inReview = Provider.of<DataStore>(context, listen: false).inReview;

    if (inReview) {
      dismissIsActive = true;
      controller.forward();
    } else {
      timer = Timer(Duration(seconds: 2), () {
        setState(() {
          dismissIsActive = true;
          controller.forward();
          timer?.cancel();
        });
      });
    }
  }
}
