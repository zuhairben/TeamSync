import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_flutter/dashboard/team_member_dashboard.dart';

// Generate mocks for FirebaseFirestore
import 'team_member_dashboard_golden_test.mocks.dart';

// Generate mocks for FirebaseFirestore
@GenerateMocks([FirebaseFirestore, CollectionReference, Query, QuerySnapshot, QueryDocumentSnapshot])
void main() {
  // Ensure Flutter test environment is initialized
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Mock Firebase initialization
    await Firebase.initializeApp();
  });

  testWidgets('Golden test for TeamMemberDashboard', (WidgetTester tester) async {
    // Mock Firestore
    final mockFirestore = MockFirebaseFirestore();
    final mockCollection = MockCollectionReference<Map<String, dynamic>>();
    final mockQuery = MockQuery<Map<String, dynamic>>();
    final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    final mockQueryDocumentSnapshot = MockQueryDocumentSnapshot<Map<String, dynamic>>();

    // Stub Firestore to return the mocked collection
    when(mockFirestore.collection('users')).thenReturn(mockCollection);

    // Stub the collection to return a mocked query
    when(mockCollection.where(any, isEqualTo: anyNamed('isEqualTo'))).thenReturn(mockQuery);

    // Stub the query to return a mocked query snapshot
    when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);

    // Stub the query snapshot to return a mocked query document snapshot
    when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);

    // Stub the query document snapshot to provide user data
    when(mockQueryDocumentSnapshot.data()).thenReturn({
      'email': 'john.doe@example.com',
      'role': 'Team Member',
    });

    // Render the widget
    await tester.pumpWidget(
      MaterialApp(
        home: TeamMemberDashboard(),
      ),
    );

    // Run the golden test
    await expectLater(
      find.byType(TeamMemberDashboard),
      matchesGoldenFile('goldens/team_member_dashboard.png'),
    );
  });
}


    // Render the widget
    await tester.pumpWidget(
      MaterialApp(
        home: TeamMemberDashboard(),
      ),
    );

    // Run the golden test
    await expectLater(
      find.byType(TeamMemberDashboard),
      matchesGoldenFile('goldens/team_member_dashboard.png'),
    );
  });
}
