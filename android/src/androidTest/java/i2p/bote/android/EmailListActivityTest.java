package i2p.bote.android;

import androidx.test.espresso.NoMatchingViewException;
import androidx.test.espresso.intent.rule.IntentsTestRule;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.drawerlayout.widget.DrawerLayout;

import org.junit.jupiter.api.BeforeEach;
import org.junit.Rule;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;

import i2p.bote.android.config.SettingsActivity;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.Espresso.openActionBarOverflowOrOptionsMenu;
import static androidx.test.espresso.action.ViewActions.click;
import static androidx.test.espresso.action.ViewActions.swipeDown;
import static androidx.test.espresso.action.ViewActions.swipeRight;
import static androidx.test.espresso.assertion.ViewAssertions.matches;
import static androidx.test.espresso.intent.Intents.intended;
import static androidx.test.espresso.intent.matcher.IntentMatchers.hasComponent;
import static androidx.test.espresso.matcher.RootMatchers.withDecorView;
import static androidx.test.espresso.matcher.ViewMatchers.isDisplayed;
import static androidx.test.espresso.matcher.ViewMatchers.withClassName;
import static androidx.test.espresso.matcher.ViewMatchers.withId;
import static androidx.test.espresso.matcher.ViewMatchers.withText;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.not;

@RunWith(AndroidJUnit4.class)
public class EmailListActivityTest {

    @Rule
    public IntentsTestRule<EmailListActivity> mActivityRule = new IntentsTestRule<>(EmailListActivity.class);

    @BeforeEach
    public void closeIntro() {
        try {
            // Close intro on first open
            onView(withId(R.id.skip_intro)).perform(click());
            // Close nav drawer on first open
            // FIXME: 6/20/15 doesn't work
            onView(withClassName(equalTo(DrawerLayout.class.getName()))).perform(swipeRight());
        } catch (NoMatchingViewException ignored) {
        }
    }

    @Test
    public void checkEmailFromActionMenuWhenNotConnected() {
        openActionBarOverflowOrOptionsMenu(mActivityRule.getActivity());
        onView(withText(R.string.check_email)).perform(click());
        onView(withText(R.string.bote_needs_to_be_connected)).inRoot(withDecorView(not(mActivityRule.getActivity().getWindow().getDecorView()))) .check(matches(isDisplayed()));
    }

    @Test
    public void checkEmailByPullWhenNotConnected() {
        onView(withId(R.id.swipe_refresh)).perform(swipeDown());
        onView(withText(R.string.bote_needs_to_be_connected)).inRoot(withDecorView(not(mActivityRule.getActivity().getWindow().getDecorView()))) .check(matches(isDisplayed()));
    }

    @org.junit.jupiter.api.Test
    public void newEmail() {
        onView(withId(R.id.promoted_action)).perform(click());
        intended(hasComponent(NewEmailActivity.class.getName()));
    }

    @Test
    public void openSettings() {
        openActionBarOverflowOrOptionsMenu(mActivityRule.getActivity());
        onView(withText(R.string.action_settings)).perform(click());
        intended(hasComponent(SettingsActivity.class.getName()));
    }

    @Test
    public void openHelp() {
        openActionBarOverflowOrOptionsMenu(mActivityRule.getActivity());
        onView(withText(R.string.help)).perform(click());
        intended(hasComponent(HelpActivity.class.getName()));
    }
}
