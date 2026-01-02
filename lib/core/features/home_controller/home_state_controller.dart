import 'package:flutter/material.dart';
import 'package:konsulta_admin/core/features/home_controller/hover_item.dart';
import 'package:konsulta_admin/core/features/home_controller/pages.dart';
import 'package:konsulta_admin/core/theme/custom_colors.dart';

class HomeStateController extends StatefulWidget {
  const HomeStateController({super.key});

  @override
  State<HomeStateController> createState() => _HomeStateControllerState();
}

class _HomeStateControllerState extends State<HomeStateController>with TickerProviderStateMixin {
  int selectedIndex = 0;
  int? expandedMenuIndex;
  int? selectedParentIndex = 0;
  int? selectedChildIndex;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;


  @override
  void initState() {
    super.initState();
    selectedParentIndex = 0;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      body: Row(
        children: [
          Container(
            height: double.infinity,
            width: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20,),
                  Image.asset('assets/images/logo_app_name.png', width: 250, ),
                  SizedBox(height: 10,),
                  Text(
                    'Admin Center',
                    style: textTheme.titleLarge?.copyWith(
                    ),
                  ),
                  SizedBox(height: 15,),
                  Divider(color: AppColors.black.withOpacity(0.1),),
                  SizedBox(height: 20,),
                  ..._buildMenuItems()
                ],
              ),
            ),
          ),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                elevation: 0,
                centerTitle: false,
                toolbarHeight: 80,
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    children: [
                      Text(
                        'Dashboard',
                        style: textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.people, color: Colors.white,),
                    ],
                  ),
                ),
              ),
              backgroundColor: Colors.black,
              body: IndexedStack(
                index: selectedIndex,
                children: pages,
              ),
            ),
          ),
        ],
      )
    );
  }

  List<Widget> _buildMenuItems() {
    List<Widget> items = [];

    for (int i = 0; i < menuItems.length; i++) {
      final hasChildren = menuItems[i]['children'] != null && 
                         (menuItems[i]['children'] as List).isNotEmpty;
      final childrenCount = hasChildren ? (menuItems[i]['children'] as List).length : 0;
      
      // Highlight parent if:
      // 1. It has no children and is selected, OR
      // 2. It has exactly one child and is selected, OR  
      // 3. It has multiple children and either parent or any child is selected
      bool isParentSelected = selectedParentIndex == i;
      
      // Main menu item
      items.add(
        HoverMenuItem(
          index: i,
          text: menuItems[i]['title'],
          selected: isParentSelected,
          icon: Icon(
            menuItems[i]['icon'], 
            color: isParentSelected ? AppColors.primary : Colors.black,
            size: 28,
            weight: 600,
          ),
          onTap: () => _onMenuTap(i),
        ),
      );
      
      // Expandable submenu
      if (expandedMenuIndex == i && hasChildren) {
        items.add(
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: (menuItems[i]['children'] as List<String>)
                    .asMap()
                    .entries
                    .map((entry) {
                  int childIndex = entry.key;
                  String childTitle = entry.value;
                  bool isChildSelected = selectedParentIndex == i && selectedChildIndex == childIndex;
                  
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => _onSubMenuTap(i, childIndex),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 54, right: 15, top: 15, bottom: 15),
                      decoration: BoxDecoration(
                        color: isChildSelected ? AppColors.backgroundColorGrey : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        childTitle,
                        style: TextStyle(
                          color: isChildSelected ? AppColors.primary : Colors.black,
                          fontSize: 14,
                          fontWeight: isChildSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      }
    }
    
    return items;
  }

  void _onMenuTap(int index) {
    final hasChildren = menuItems[index]['children'] != null && 
                       (menuItems[index]['children'] as List).isNotEmpty;
    final childrenCount = hasChildren ? (menuItems[index]['children'] as List).length : 0;
    
    setState(() {
      if (hasChildren) {
        if (childrenCount == 1) {
          // If only one child, go directly to that page
          selectedParentIndex = index;
          selectedChildIndex = 0;
          selectedIndex = _getPageIndex(index, 0);
          // Close any expanded menu
          if (expandedMenuIndex != null) {
            _animationController.reverse().then((_) {
              setState(() {
                expandedMenuIndex = null;
              });
            });
          }
        } else {
          // Multiple children, just toggle the expansion
          if (expandedMenuIndex == index) {
            // Close the expanded menu
            selectedParentIndex = null;
            selectedChildIndex = null;
            _animationController.reverse().then((_) {
              setState(() {
                expandedMenuIndex = null;
              });
            });
          } else {
            // Expand this menu and highlight the parent
            selectedParentIndex = index;
            selectedChildIndex = null;
            if (expandedMenuIndex != null) {
              // Close current menu first
              _animationController.reverse().then((_) {
                setState(() {
                  expandedMenuIndex = index;
                  _animationController.forward();
                });
              });
            } else {
              // No menu currently expanded, just expand this one
              expandedMenuIndex = index;
              _animationController.forward();
            }
          }
        }
      } else {
        // Handle menu items without children (normal click)
        selectedParentIndex = index;
        selectedChildIndex = null;
        selectedIndex = index; // Show this page
        // Close any expanded menu if clicking a menu without children
        if (expandedMenuIndex != null) {
          _animationController.reverse().then((_) {
            setState(() {
              expandedMenuIndex = null;
            });
          });
        }
      }
    });
  }

  void _onSubMenuTap(int parentIndex, int childIndex) {
    setState(() {
      selectedParentIndex = parentIndex;
      selectedChildIndex = childIndex;
      // Calculate the page index based on parent and child
      selectedIndex = _getPageIndex(parentIndex, childIndex);
    });
    print('Selected: ${menuItems[parentIndex]['title']} -> ${menuItems[parentIndex]['children'][childIndex]}');
  }

  int _getPageIndex(int parentIndex, int childIndex) {
    // This method maps parent/child combinations to specific page indices
    // You'll need to adjust this based on how your pages are organized
    
    int pageIndex = 0;
    
    // Calculate cumulative index based on menu structure
    for (int i = 0; i < parentIndex; i++) {
      // Add 1 for the parent page itself
      pageIndex += 1;
      // Add count of children pages
      if (menuItems[i]['children'] != null) {
        pageIndex += (menuItems[i]['children'] as List).length;
      }
    }
    
    // Add 1 for the current parent page
    pageIndex += 1;
    
    // Add the child index
    pageIndex += childIndex;
    
    return pageIndex;
  }
}