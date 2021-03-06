package i2p.bote.android.intro;

import android.app.Instrumentation;

import androidx.appcompat.app.AppCompatActivity;
import androidx.test.espresso.intent.rule.IntentsTestRule;
import androidx.test.ext.junit.runners.AndroidJUnit4;

import org.junit.Rule;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;

import i2p.bote.android.R;
import i2p.bote.android.config.SetPasswordActivity;
import i2p.bote.android.identities.EditIdentityActivity;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.action.ViewActions.click;
import static androidx.test.espresso.assertion.ViewAssertions.matches;
import static androidx.test.espresso.intent.Intents.intended;
import static androidx.test.espresso.intent.Intents.intending;
import static androidx.test.espresso.intent.matcher.IntentMatchers.hasComponent;
import static androidx.test.espresso.matcher.ViewMatchers.withId;
import static androidx.test.espresso.matcher.ViewMatchers.withText;

@RunWith(AndroidJUnit4.class)
public class SetupActivityTest {

    @Rule
    public IntentsTestRule<SetupActivity> mRule = new IntentsTestRule<>(SetupActivity.class);

    @Test
    public void setPassword() {
        // Check we are on "Set password" page
        onView(withId(R.id.textView)).check(matches(withText(R.string.set_password)));

        onView(withId(R.id.button_set_password)).perform(click());
        intended(hasComponent(SetPasswordActivity.class.getName()));
    }

    @org.junit.jupiter.api.Test
    public void nextPageAfterSetPassword() {
        // Check we are on "Set password" page
        onView(withId(R.id.textView)).check(matches(withText(R.string.set_password)));

        intending(hasComponent(SetPasswordActivity.class.getName())).respondWith(new Instrumentation.ActivityResult(AppCompatActivity.RESULT_OK, null));

        onView(withId(R.id.button_set_password)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText(R.string.create_identity)));
    }

    @org.junit.jupiter.api.Test
    public void createIdentity() {
        onView(withId(R.id.textView)).check(matches(withText(R.string.set_password)));
        onView(withId(R.id.button_skip)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText(R.string.create_identity)));

        onView(withId(R.id.button_set_password)).perform(click());
        intended(hasComponent(EditIdentityActivity.class.getName()));
    }

    @Test
    public void nextPageAfterCreateIdentity() {
        // Check we are on "Create identity" page
        onView(withId(R.id.button_skip)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText(R.string.create_identity)));

        intending(hasComponent(EditIdentityActivity.class.getName())).respondWith(new Instrumentation.ActivityResult(AppCompatActivity.RESULT_OK, null));

        onView(withId(R.id.button_set_password)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText(R.string.setup_finished)));
    }

    @org.junit.jupiter.api.Test
    public void setupFinished() {
        onView(withId(R.id.textView)).check(matches(withText(R.string.set_password)));
        onView(withId(R.id.button_skip)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText(R.string.create_identity)));
        onView(withId(R.id.button_skip)).perform(click());
        onView(withId(R.id.textView)).check(matches(withText(R.string.setup_finished)));

        onView(withId(R.id.button_finish)).perform(click());
        // TODO check result
    }
}