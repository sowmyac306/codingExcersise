@isTest
private class ArgumentNullExceptionTest {
    private static final String MY_VARIABLE = 'myVariable';

    @isTest
    private static void throwIfNull_isNotNull_expectNoException() {
        try {
            Test.startTest();
            ArgumentNullException.throwIfNull('testString', MY_VARIABLE);
        } catch (Exception e) {
            System.assert(false, 'No exception should have been thrown. Exception: ' + e.getMessage());
        } finally {
            Test.stopTest();
        }
    }

    @isTest
    private static void throwIfNull_isNull_expectException() {
        try {
            Test.startTest();
            ArgumentNullException.throwIfNull((String)null, MY_VARIABLE);

            TestHelper.expectedArgumentNullException();
        } catch (Exception e) {
            TestHelper.assertArgumentNullException(e, MY_VARIABLE);
        } finally {
            Test.stopTest();
        }
    }

    @isTest
    private static void throwIfNull_handlerIsNotNull_expectNoException() {
        try {
            IHandleMessages testHandler = new IncomingLeadHandler();
            Test.startTest();
            ArgumentNullException.throwIfNull(testHandler);
        } catch (Exception e) {
            System.assert(false, 'No exception should have been thrown. Exception: ' + e.getMessage());
        } finally {
            Test.stopTest();
        }
    }

    @isTest
    private static void throwIfNull_handlerIsNull_expectException() {
        try {
            IHandleMessages testHandler = null;
            Test.startTest();
            ArgumentNullException.throwIfNull(testHandler);

            TestHelper.expectedArgumentNullException();
        } catch (Exception e) {
            System.assert(true, 'Exception should have been thrown. Exception: ' + e.getMessage());
        } finally {
            Test.stopTest();
        }
    }
}