package com.bitechular.babycare.api.dto.babyaction;

import java.util.Date;
import java.util.List;

public class SyncResponse<Type> {
    public List<Type> items;
    public long syncedDate;

    public SyncResponse(List<Type> items, Date syncedDate) {
        this.items = items;
        this.syncedDate = syncedDate.getTime();
    }

    public List<Type> getItems() {
        return items;
    }

    public void setItems(List<Type> items) {
        this.items = items;
    }

    public long getSyncedDate() {
        return syncedDate;
    }

    public void setSyncedDate(long syncedDate) {
        this.syncedDate = syncedDate;
    }
}
