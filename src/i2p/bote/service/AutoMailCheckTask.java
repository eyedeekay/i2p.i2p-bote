/**
 * Copyright (C) 2009  HungryHobo@mail.i2p
 * 
 * The GPG fingerprint for HungryHobo@mail.i2p is:
 * 6DD3 EAA2 9990 29BC 4AD2 7486 1E2C 7B61 76DC DC12
 * 
 * This file is part of I2P-Bote.
 * I2P-Bote is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * I2P-Bote is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with I2P-Bote.  If not, see <http://www.gnu.org/licenses/>.
 */

package i2p.bote.service;

import java.util.concurrent.TimeUnit;

import i2p.bote.I2PBote;
import i2p.bote.network.NetworkStatus;
import net.i2p.util.I2PAppThread;

public class AutoMailCheckTask extends I2PAppThread {
    private long interval;   // in milliseconds
    
    /**
     * 
     * @param interval In minutes
     */
    public AutoMailCheckTask(int interval) {
        this.interval = TimeUnit.MINUTES.toMillis(interval);
    }

    @Override
    public void run() {
        while (true) {
            long timeSinceLastCheck = System.currentTimeMillis() - I2PBote.getInstance().getLastMailCheckTime();
            try {
                if (I2PBote.getInstance().getNetworkStatus() != NetworkStatus.CONNECTED)   // if not connected, use a shorter wait interval
                    TimeUnit.MINUTES.sleep(1);
                else if (timeSinceLastCheck < interval)
                    Thread.sleep(interval - timeSinceLastCheck);
                else
                    I2PBote.getInstance().checkForMail();
            } catch (InterruptedException e) {
                return;
            }
        }
    }
    
    public void shutDown() {
        interrupt();
    }
}