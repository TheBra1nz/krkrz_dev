# Console

Debug.console extensions

## Members

### Methods

- [restoreMaxmimize](#restoremaxmimize)
- [maxmimize](#maxmimize)
- [getRect](#getrect)
- [setPos](#setpos)
- [getPlacement](#getplacement)
- [setPlacement](#setplacement)
- [bringAfter](#bringafter)

---

### restoreMaxmimize

Method

**Description**

Restores from the maximized state (works around the window size being wrong on the next launch if the console is closed while maximized)

---

### maxmimize

Method

**Description**

Maximizes the window

---

### getRect

Method

**Description**

Gets the position and size

---

### setPos

Method

**Arguments**

| Arguments | Default | Description |
| --- | --- | --- |
| `x` | `&nbsp;` |  |
| `y` | `&nbsp;` |  |
| `w` | `&nbsp;` |  |
| `h` | `&nbsp;` |  |

**Description**

Sets the position and size

---

### getPlacement

Method

**Description**

Gets the WindowPlacement

---

### setPlacement

Method

**Arguments**

| Arguments | Default | Description |
| --- | --- | --- |
| `dict` | `&nbsp;` |  |

**Description**

Sets the WindowPlacement

---

### bringAfter

Method

**Arguments**

| Arguments | Default | Description |
| --- | --- | --- |
| `win` | `&nbsp;` |  |

**Description**

Changes the z-order (fails unless the window has been created at least once after startup by setting visible=true)

---
